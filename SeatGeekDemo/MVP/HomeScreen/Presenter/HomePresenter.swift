//
//  HomePresenter.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation
import SeatGeekAPI

protocol HomePresenterProtocol: class {
    func reloadTableView()
    func showError(title: String, message: String)
}

class HomePresenter {

    // MARK: - Properties
    private var view: HomePresenterProtocol?
    private var productModel: ProductModel?
    private var productFilteredModel: ProductModel?
    private var page: Int = 1
    public var isFiltering: Bool = false
    private var filteredText: String?
    var numberOfRows: Int {
        if isFiltering {
            return productFilteredModel?.eventModel.count ?? 0
        } else {
            return productModel?.eventModel.count ?? 0
        }
    }

    // MARK: - Methods
    /// Initial setup of presenter
    init(with view: HomePresenterProtocol?) {
        self.view = view
    }

    /// Function to reset pagination data
    func reset() {
        page = 1
    }

    /// Function for pagination hit
    func paginationHit() {
        if isFiltering {
            if self.productFilteredModel?.isPaginationRequired == true {
                page += 1
                if let text = filteredText {
                    self.getFilteredList(forText: text, isFromPagination: true, completion: { (_) in
                        DispatchQueue.main.async {
                            self.view?.reloadTableView()
                        }
                    })
                }
            }
        } else {
            if self.productModel?.isPaginationRequired == true {
                page += 1
                self.getAllEventsList(isFromPagination: true)
            }
        }
    }

    /// Function to get the event model for the particular index
    /// - Parameters:
    ///   - indexPath: takes the indexpath to return model
    /// - Returns: event detail model for selected index
    func getEventsDataModelAtIndex(index: Int) -> SGEvent? {
        if isFiltering {
            if let model = self.productFilteredModel?.eventModel {
                if model.count > index {
                    return model[index]
                } else {
                    return nil
                }
            }
        } else {
            if let model = self.productModel?.eventModel {
                if model.count > index {
                    return model[index]
                } else {
                    return nil
                }
            }
        }
        return nil
    }

    /// Function to get events array all together
    /// - Returns: entire events array
    func getAllEventsArray() -> [SGEvent]? {
        if let model = self.productModel?.eventModel, model.count > 0 {
            return model
        }
        return nil
    }

    /// Function to get Filtered list
    /// - Parameters:
    ///   - text: take the search string as input
    ///   - isFromPagination: takes the bool as input
    ///   - completion: return completion block on completion of request
    func getFilteredList(forText text: String, isFromPagination: Bool = false, completion: @escaping (_ response: [SGEvent]?) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            self.view?.showError(title: "", message: "No Internet Connection available.")
            return
        }
        ProgressHUD.present(animated: true)
        filteredText = text
        // find all 'new york mets' events
        let events = SGEventSet.eventsSet()
        events?.query?.search = text
        events?.onPageLoaded = { (results: NSOrderedSet) -> Void in
            ProgressHUD.dismiss(animated: true)
            var tempEvents = [SGEvent]()
            for event in results {
                if let resultEvent = (event as? SGEvent) {
                    tempEvents.append(resultEvent)
                }
            }
            if !isFromPagination {
                self.productFilteredModel = ProductModel(events: tempEvents)
            } else {
                self.productFilteredModel?.eventModel += tempEvents
            }
            completion(self.productFilteredModel?.eventModel)
        }
        events?.onPageLoadFailed = { (error: Error) -> Void in
            ProgressHUD.dismiss(animated: true)
            print("Error: %@", error)
            completion(nil)
        }
        events?.fetchPage(Int32(page))
    }

    /// Function to get all events list
    /// - Parameters:
    ///   - isFromPagination: takes the bool as input
    func getAllEventsList(isFromPagination: Bool = false) {

        guard Reachability.isConnectedToNetwork() else {
            self.view?.showError(title: "", message: "No Internet Connection available.")
            return
        }
        ProgressHUD.present(animated: true)
        filteredText = nil
        // find all 'new york mets' events
        let events = SGEventSet.eventsSet()
        //events?.query?.search = "new york mets"
        events?.query?.perPage = 15
        events?.onPageLoaded = { (results: NSOrderedSet) -> Void in
            ProgressHUD.dismiss(animated: true)
            var tempEvents = [SGEvent]()
            for event in results {
                if let resultEvent = (event as? SGEvent) {
                    tempEvents.append(resultEvent)
                }
            }
            if !isFromPagination {
                self.productModel = ProductModel(events: tempEvents)
            } else {
                self.productModel?.eventModel += tempEvents
            }
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
        events?.onPageLoadFailed = { (error: Error) -> Void in
            ProgressHUD.dismiss(animated: true)
            print("Error: %@", error)
        }
        events?.fetchPage(Int32(page))
    }

}
