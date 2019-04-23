//
//  View+Extension.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//
import UIKit

@IBDesignable
// MARK: - UIView Designable
extension UIView {

    // MARK: - Border color
    @IBInspectable var borderColor: UIColor? {
        get {
            return self.borderColor
        } set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    // MARK: - Border Width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }

    // MARK: - corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: newValue ?? .gray])
        }
    }
}
