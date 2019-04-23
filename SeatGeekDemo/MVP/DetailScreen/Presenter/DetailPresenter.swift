//
//  DetailPresenter.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation

protocol DetailPresenterProtocol: class {

}

class DetailPresenter {

    // MARK: - Properties
    var view: DetailPresenterProtocol?

    // MARK: - Methods
    /// Initial setup of presenter
    init(view: DetailPresenterProtocol?) {
        self.view = view
    }

}
