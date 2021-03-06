import Foundation
import UIKit
import SolidRoundedButtonNode
import TelegramPresentationData

public extension SolidRoundedButtonTheme {
    convenience init(theme: PresentationTheme) {
        self.init(backgroundColor: theme.list.itemCheckColors.fillColor, backgroundColors: [], foregroundColor: theme.list.itemCheckColors.foregroundColor)
    }
}
