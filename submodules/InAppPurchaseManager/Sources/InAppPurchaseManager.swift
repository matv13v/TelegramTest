import Foundation
import CoreLocation
import SwiftSignalKit
import StoreKit
import Postbox
import TelegramCore

public final class InAppPurchaseManager: NSObject {
    public final class Product {
        let skProduct: SKProduct
        
        init(skProduct: SKProduct) {
            self.skProduct = skProduct
        }
        
        public var price: String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = self.skProduct.priceLocale
            return numberFormatter.string(from: self.skProduct.price) ?? ""
        }
    }
    
    public enum PurchaseState {
        case purchased(transactionId: String)
    }
    
    public enum PurchaseError {
        case generic
        case cancelled
        case network
        case notAllowed
        case cantMakePayments
        case assignFailed
    }
    
    public enum RestoreState {
        case succeed
        case failed
    }
    
    private final class PaymentTransactionContext {
        var state: SKPaymentTransactionState?
        let subscriber: (TransactionState) -> Void
        
        init(subscriber: @escaping (TransactionState) -> Void) {
            self.subscriber = subscriber
        }
    }
    
    private enum TransactionState {
        case purchased(transactionId: String?)
        case restored(transactionId: String?)
        case purchasing
        case failed(error: SKError?)
        case assignFailed
        case deferred
    }
    
    private let engine: TelegramEngine
    private let premiumProductId: String
    
    private var products: [Product] = []
    private var productsPromise = Promise<[Product]>()
    private var productRequest: SKProductsRequest?
    
    private let stateQueue = Queue()
    private var paymentContexts: [String: PaymentTransactionContext] = [:]
        
    private var onRestoreCompletion: ((RestoreState) -> Void)?
    
    private let disposableSet = DisposableDict<String>()
    
    public init(engine: TelegramEngine, premiumProductId: String) {
        self.engine = engine
        self.premiumProductId = premiumProductId
        
        super.init()
        
        SKPaymentQueue.default().add(self)
        self.requestProducts()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    private func requestProducts() {
        guard !self.premiumProductId.isEmpty else {
            return
        }
        Logger.shared.log("InAppPurchaseManager", "Requesting products")
        let productRequest = SKProductsRequest(productIdentifiers: Set([self.premiumProductId]))
        productRequest.delegate = self
        productRequest.start()
        
        self.productRequest = productRequest
    }
    
    public var availableProducts: Signal<[Product], NoError> {
        if self.products.isEmpty && self.productRequest == nil {
            self.requestProducts()
        }
        return self.productsPromise.get()
    }
    
    public func restorePurchases(completion: @escaping (RestoreState) -> Void) {
        Logger.shared.log("InAppPurchaseManager", "Restoring purchases")
        self.onRestoreCompletion = completion
        
        let paymentQueue = SKPaymentQueue.default()
        paymentQueue.restoreCompletedTransactions()
    }
    
    public func finishAllTransactions() {
        Logger.shared.log("InAppPurchaseManager", "Finishing all transactions")
        
        let paymentQueue = SKPaymentQueue.default()
        let transactions = paymentQueue.transactions
        for transaction in transactions {
            paymentQueue.finishTransaction(transaction)
        }
    }
    
    public func buyProduct(_ product: Product) -> Signal<PurchaseState, PurchaseError> {
        if !self.canMakePayments {
            return .fail(.cantMakePayments)
        }
        let accountPeerId = "\(self.engine.account.peerId.toInt64())"
        
        Logger.shared.log("InAppPurchaseManager", "Buying: account \(accountPeerId), product \(product.skProduct.productIdentifier), price \(product.price)")
        
        let payment = SKMutablePayment(product: product.skProduct)
        payment.applicationUsername = accountPeerId
        SKPaymentQueue.default().add(payment)
        
        let productIdentifier = payment.productIdentifier
        let signal = Signal<PurchaseState, PurchaseError> { subscriber in
            let disposable = MetaDisposable()
            
            self.stateQueue.async {
                let paymentContext = PaymentTransactionContext(subscriber: { state in
                    switch state {
                        case let .purchased(transactionId), let .restored(transactionId):
                            if let transactionId = transactionId {
                                subscriber.putNext(.purchased(transactionId: transactionId))
                                subscriber.putCompletion()
                            } else {
                                subscriber.putError(.generic)
                            }
                        case let .failed(error):
                            if let error = error {
                                let mappedError: PurchaseError
                                switch error.code {
                                    case .paymentCancelled:
                                        mappedError = .cancelled
                                    case .cloudServiceNetworkConnectionFailed, .cloudServicePermissionDenied:
                                        mappedError = .network
                                    case .paymentNotAllowed, .clientInvalid:
                                        mappedError = .notAllowed
                                    default:
                                        mappedError = .generic
                                }
                                subscriber.putError(mappedError)
                            } else {
                                subscriber.putError(.generic)
                            }
                        case .assignFailed:
                            subscriber.putError(.assignFailed)
                        case .deferred, .purchasing:
                            break
                    }
                })
                self.paymentContexts[productIdentifier] = paymentContext
                
                disposable.set(ActionDisposable { [weak paymentContext] in
                    self.stateQueue.async {
                        if let current = self.paymentContexts[productIdentifier], current === paymentContext {
                            self.paymentContexts.removeValue(forKey: productIdentifier)
                        }
                    }
                })
            }
            
            return disposable
        }
        return signal
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.productRequest = nil
        
        Queue.mainQueue().async {
            let products = response.products.map { Product(skProduct: $0) }
             
            Logger.shared.log("InAppPurchaseManager", "Received products \(products.map({ $0.skProduct.productIdentifier }).joined(separator: ", "))")
            self.productsPromise.set(.single(products))
        }
    }
}

private func getReceiptData() -> Data? {
    var receiptData: Data?
    if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
        do {
            receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
        } catch {
            Logger.shared.log("InAppPurchaseManager", "Couldn't read receipt data with error: \(error.localizedDescription)")
        }
    }
    return receiptData
}

extension InAppPurchaseManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        self.stateQueue.async {
            let accountPeerId = "\(self.engine.account.peerId.toInt64())"
            var transactionsToAssign: [SKPaymentTransaction] = []
            for transaction in transactions {
                if let applicationUsername = transaction.payment.applicationUsername, applicationUsername != accountPeerId {
                    continue
                }
                
                let productIdentifier = transaction.payment.productIdentifier
                let transactionState: TransactionState?
                switch transaction.transactionState {
                    case .purchased:
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transaction \(transaction.transactionIdentifier ?? ""), original transaction \(transaction.original?.transactionIdentifier ?? "none") purchased")
                    
                        transactionState = .purchased(transactionId: transaction.transactionIdentifier)
                        transactionsToAssign.append(transaction)
                    case .restored:
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transaction \(transaction.transactionIdentifier ?? ""), original transaction \(transaction.original?.transactionIdentifier ?? "") restroring")
                        let transactionIdentifier = transaction.transactionIdentifier
                        transactionState = .restored(transactionId: transactionIdentifier)
                    case .failed:
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transaction \(transaction.transactionIdentifier ?? "") failed \((transaction.error as? SKError)?.localizedDescription ?? "")")
                        transactionState = .failed(error: transaction.error as? SKError)
                        queue.finishTransaction(transaction)
                    case .purchasing:
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transaction \(transaction.transactionIdentifier ?? "") purchasing")
                        transactionState = .purchasing
                    case .deferred:
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transaction \(transaction.transactionIdentifier ?? "") deferred")
                        transactionState = .deferred
                    default:
                        transactionState = nil
                }
                if let transactionState = transactionState {
                    if let context = self.paymentContexts[productIdentifier] {
                        context.subscriber(transactionState)
                    }
                }
            }
            
            if !transactionsToAssign.isEmpty {
                let transactionIds = transactionsToAssign.compactMap({ $0.transactionIdentifier }).joined(separator: ", ")
                Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), sending receipt for transactions [\(transactionIds)]")
                
                self.disposableSet.set(
                    self.engine.payments.sendAppStoreReceipt(receipt: getReceiptData() ?? Data(), restore: false).start(error: { [weak self] _ in
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transactions [\(transactionIds)] failed to assign")
                        for transaction in transactions {
                            self?.stateQueue.async {
                                if let strongSelf = self, let context = strongSelf.paymentContexts[transaction.payment.productIdentifier] {
                                    context.subscriber(.assignFailed)
                                }
                            }
                            queue.finishTransaction(transaction)
                        }
                    }, completed: {
                        Logger.shared.log("InAppPurchaseManager", "Account \(accountPeerId), transactions [\(transactionIds)] successfully assigned")
                        for transaction in transactions {
                            queue.finishTransaction(transaction)
                        }
                    }),
                    forKey: transactionIds
                )
            }
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        Queue.mainQueue().async {
            if let onRestoreCompletion = self.onRestoreCompletion {
                Logger.shared.log("InAppPurchaseManager", "Transactions restoration finished")
                onRestoreCompletion(.succeed)
                self.onRestoreCompletion = nil
                
                if let receiptData = getReceiptData() {
                    self.disposableSet.set(
                        self.engine.payments.sendAppStoreReceipt(receipt: receiptData, restore: true).start(completed: {
                            Logger.shared.log("InAppPurchaseManager", "Sent restored receipt")
                        }),
                        forKey: "restore"
                    )
                }
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        Queue.mainQueue().async {
            if let onRestoreCompletion = self.onRestoreCompletion {
                Logger.shared.log("InAppPurchaseManager", "Transactions restoration failed with error \((error as? SKError)?.localizedDescription ?? "")")
                onRestoreCompletion(.failed)
                self.onRestoreCompletion = nil
            }
        }
    }
}
