//
//  ChartDetailsView.swift
//  GraphTest
//
//  Created by Andrew Solovey on 14/03/2019.
//  Copyright © 2019 Andrei Salavei. All rights reserved.
//

import UIKit
import GraphCore
import AppBundle

private let cornerRadius: CGFloat = 5
private let verticalMargins: CGFloat = 8
private var labelHeight: CGFloat = 18
private var margin: CGFloat = 10
private var prefixLabelWidth: CGFloat = 29
private var textLabelWidth: CGFloat = 96
private var valueLabelWidth: CGFloat = 65

class ChartDetailsView: UIControl {
    let titleLabel = UILabel()
    let arrowView = UIImageView()
    let activityIndicator = UIActivityIndicatorView()
    let arrowButton = UIButton()
    
    var prefixViews: [UILabel] = []
    var labelsViews: [UILabel] = []
    var valuesViews: [UILabel] = []

    private var viewModel: ChartDetailsViewModel?
    private var theme: ChartTheme = ChartTheme.defaultDayTheme
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        addTarget(self, action: #selector(didTapWhole), for: .touchUpInside)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        arrowView.image = UIImage(bundleImageName: "Chart/arrow_right")
        arrowView.contentMode = .scaleAspectFill

        arrowButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(arrowView)
        addSubview(arrowButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewModel: ChartDetailsViewModel, animated: Bool) {
        self.viewModel = viewModel
        
        titleLabel.setText(viewModel.title, animated: false)
        titleLabel.setVisible(!viewModel.title.isEmpty, animated: false)
        arrowView.setVisible(viewModel.showArrow, animated: false)
        arrowButton.isUserInteractionEnabled = viewModel.showArrow
        
        let width: CGFloat = margin * 2 + (viewModel.showPrefixes ? (prefixLabelWidth + margin) : 0) + textLabelWidth + valueLabelWidth
        var y: CGFloat = verticalMargins

        if (!viewModel.title.isEmpty || viewModel.showArrow) {
            titleLabel.frame = CGRect(x: margin, y: y, width: width, height: labelHeight)
            arrowView.frame = CGRect(x: width - 6 - margin, y: margin, width: 6, height: 10)
            y += labelHeight
        }
        let labelsCount: Int = viewModel.values.count + ((viewModel.totalValue == nil) ? 0 : 1)

        arrowButton.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 30.0)
        
        setLabelsCount(array: &prefixViews,
                       count: viewModel.showPrefixes ? labelsCount : 0,
                       font: UIFont.systemFont(ofSize: 12, weight: .bold))
        setLabelsCount(array: &labelsViews,
                       count: labelsCount,
                       font: UIFont.systemFont(ofSize: 12, weight: .regular),
                       textAlignment: .left)
        setLabelsCount(array: &valuesViews,
                       count: labelsCount,
                       font: UIFont.systemFont(ofSize: 12, weight: .bold))
        
        UIView.perform(animated: animated, animations: {
            for (index, value) in viewModel.values.enumerated() {
                var x: CGFloat = margin
                if viewModel.showPrefixes {
                    let prefixLabel = self.prefixViews[index]
                    prefixLabel.textColor = self.theme.chartDetailsTextColor
                    prefixLabel.setText(value.prefix, animated: false)
                    prefixLabel.frame = CGRect(x: x, y: y, width: prefixLabelWidth, height: labelHeight)
                    x += prefixLabelWidth + margin
                    prefixLabel.alpha = value.visible ? 1 : 0
                }
                let titleLabel = self.labelsViews[index]
                titleLabel.setTextColor(self.theme.chartDetailsTextColor, animated: false)
                titleLabel.setText(value.title, animated: false)
                titleLabel.frame = CGRect(x: x, y: y, width: textLabelWidth, height: labelHeight)
                titleLabel.alpha = value.visible ? 1 : 0
                x += textLabelWidth
                
                let valueLabel = self.valuesViews[index]
                valueLabel.setTextColor(value.color, animated: false)
                valueLabel.setText(value.value, animated: false)
                valueLabel.frame = CGRect(x: x, y: y, width: valueLabelWidth, height: labelHeight)
                valueLabel.alpha = value.visible ? 1 : 0
                
                if value.visible {
                    y += labelHeight
                }
            }
            if let value = viewModel.totalValue {
                var x: CGFloat = margin
                if viewModel.showPrefixes {
                    let prefixLabel = self.prefixViews[viewModel.values.count]
                    prefixLabel.textColor = self.theme.chartDetailsTextColor
                    prefixLabel.setText(value.prefix, animated: false)
                    prefixLabel.frame = CGRect(x: x, y: y, width: prefixLabelWidth, height: labelHeight)
                    prefixLabel.alpha = value.visible ? 1 : 0
                    x += prefixLabelWidth + margin
                }
                let titleLabel = self.labelsViews[viewModel.values.count]
                titleLabel.setTextColor(self.theme.chartDetailsTextColor, animated: false)
                titleLabel.setText(value.title, animated: false)
                titleLabel.frame = CGRect(x: x, y: y, width: textLabelWidth, height: labelHeight)
                titleLabel.alpha = value.visible ? 1 : 0
                x += textLabelWidth
                
                let valueLabel = self.valuesViews[viewModel.values.count]
                valueLabel.setTextColor(self.theme.chartDetailsTextColor, animated: false)
                valueLabel.setText(value.value, animated: false)
                valueLabel.frame = CGRect(x: x, y: y, width: valueLabelWidth, height: labelHeight)
                valueLabel.alpha = value.visible ? 1 : 0
            }
        })
    }
    
    override var intrinsicContentSize: CGSize {
        if let viewModel = viewModel {
            let height = ((!viewModel.title.isEmpty || viewModel.showArrow) ? labelHeight : 0) +
                (CGFloat(viewModel.values.filter({ $0.visible }).count) * labelHeight) +
                (viewModel.totalValue?.visible == true ? labelHeight : 0) +
                verticalMargins * 2
            let width: CGFloat = margin * 2 +
                (viewModel.showPrefixes ? (prefixLabelWidth + margin) : 0) +
                textLabelWidth +
                valueLabelWidth
            
            return CGSize(width: width,
                          height: height)
        } else {
            return CGSize(width: 140,
                          height: labelHeight + verticalMargins)
        }
    }
    
    @objc private func didTap() {
        viewModel?.tapAction?()
    }
    
    @objc private func didTapWhole() {
        viewModel?.hideAction?()
    }
    
    func setLabelsCount(array: inout [UILabel],
                        count: Int,
                        font: UIFont,
                        textAlignment: NSTextAlignment = .right) {
        while array.count > count {
            let subview = array.removeLast()
            subview.removeFromSuperview()
        }
        while array.count < count {
            let label = UILabel()
            label.font = font
            label.textAlignment = textAlignment
            addSubview(label)
            array.append(label)
        }
    }
}

extension ChartDetailsView: ChartThemeContainer {
    func apply(theme: ChartTheme, animated: Bool) {
        self.theme = theme
        self.titleLabel.setTextColor(theme.chartDetailsTextColor, animated: animated)
        if let viewModel = self.viewModel {
            self.setup(viewModel: viewModel, animated: animated)
        }
        UIView.perform(animated: animated) {
            self.arrowView.tintColor = theme.chartDetailsArrowColor
            self.backgroundColor = theme.chartDetailsViewColor
        }
    }
}

// MARK: UIStackView+removeAllArrangedSubviews
public extension UIStackView {
    func setLabelsCount(_ count: Int,
                        font: UIFont,
                        huggingPriority: UILayoutPriority,
                        textAlignment: NSTextAlignment = .right) {
        while arrangedSubviews.count > count {
            let subview = arrangedSubviews.last!
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        while arrangedSubviews.count < count {
            let label = UILabel()
            label.font = font
            label.textAlignment = textAlignment
            label.setContentHuggingPriority(huggingPriority, for: .horizontal)
            label.setContentHuggingPriority(huggingPriority, for: .vertical)
            label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
            label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
            addArrangedSubview(label)
        }
    }
    
    func label(at index: Int) -> UILabel {
        return arrangedSubviews[index] as! UILabel
    }
    
    func removeAllArrangedSubviews() {
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

// MARK: UIStackView+addArrangedSubviews
public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach({ addArrangedSubview($0) })
    }
}

// MARK: UIStackView+insertArrangedSubviews
public extension UIStackView {
    func insertArrangedSubviews(_ views: [UIView], at index: Int) {
        views.reversed().forEach({ insertArrangedSubview($0, at: index) })
    }
}
