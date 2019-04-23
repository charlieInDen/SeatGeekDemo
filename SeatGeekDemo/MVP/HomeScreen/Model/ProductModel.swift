//
//  ProductModel.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation

struct ProductModel {
    var eventModel: [SGEvent]

    var isPaginationRequired: Bool {
        return true
    }

    init(events: [SGEvent]) {
        self.eventModel = events
    }
}

struct EventInfoModel: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var userImage: String
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case userImage = "avatar"
    }
}

extension SGEvent {
    var imageUrl: URL? {
        get {
            var tempUrl: URL?
            if let imageData = self.venue.imageURL {
                if let url: URL =  URL(string: imageData) {
                    tempUrl = url
                }
            } else if let performer = self.performers.first as? SGPerformer,
                let imageData = performer.imageURL {
                if let url: URL =  URL(string: imageData) {
                    tempUrl = url
                }
            }
            return tempUrl
        }
    }
}
