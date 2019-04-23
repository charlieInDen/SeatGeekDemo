//
//  View+Extension.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView
extension UIView {
    func shadowPath(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
    }

    func createGradientLayer() {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor(red: 0 / 255.0, green: 128 / 255.0, blue: 198 / 255.0, alpha: 1.0).cgColor, UIColor(red: 0 / 255.0, green: 84 / 255.0, blue: 147 / 255.0, alpha: 1.0).cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - TableView
extension  UITableView {

    func indexPathForSubView(subview: UIView) -> IndexPath {
        if let superview = subview.superview {
            let location: CGPoint = superview.convert(subview.center, to: self)
            if let indexPath = self.indexPathForRow(at: location) {
                return indexPath
            }
        }

        fatalError("UITableView:- Not able find index path for row location")

    }

    func hideLastCellLine() {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        view.backgroundColor = UIColor.clear
        self.tableFooterView = view
    }

    func scrollEnableOnlyForExtraContent() {
        if self.contentSize.height > self.frame.size.height {
            self.isScrollEnabled = true
        } else {
            self.isScrollEnabled = false
        }
    }

    func registerCell(_ nibName: String, identifier: String = "", bundle: Bundle? = nil ) {
        var identifier = identifier
        if identifier.isEmpty {
            identifier = nibName
        }
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: identifier)
    }

    func registerHeaderFooter(_ nibName: String, identifier: String = "", bundle: Bundle? = nil ) {
        var identifier = identifier
        if identifier.isEmpty {
            identifier = nibName
        }
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

protocol Identificable { }

extension Identificable {
    static var identifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: Identificable {}

// MARK: - UIViewController
extension UIViewController: Identificable {}

extension UILabel {

    func estimatedHeightOfLabel() -> CGFloat {
        let size = CGSize(width: self.frame.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: self.font]
        guard let height = self.text?.boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key: Any], context: nil).height else { return 21.0 }
        return height + 20.0
    }

}
