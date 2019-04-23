//
//  ViewController+Extension.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

extension UIViewController {
    class func instantiateFromMainStoryboard() -> Self? {
        return instantiateFromStoryboardHelper("Main")
    }

    class func instantiateFromStoryboardHelper<T>(_ name: String) -> T? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T
        return controller
    }
}

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
