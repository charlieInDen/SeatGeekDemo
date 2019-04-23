//
//  Image+Extension.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation

extension UIImage {
    class func alwaysRendering(named: String) -> UIImage? {
        return UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
    }
}
