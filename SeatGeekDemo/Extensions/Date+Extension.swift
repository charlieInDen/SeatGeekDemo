//
//  Date+Extension.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation

extension Date {
    var localizedDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy hh:mm a"
            return formatter.string(from: self)
        }
    }
}
