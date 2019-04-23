//
//  DetailViewController.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    var event: SGEvent?
    private var presenter: DetailPresenter!
    var isFavourite: Bool = false {
        didSet {
            favouriteButton.tintColor = self.isFavourite ? .red : .lightGray
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var venuImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    // MARK: - Button Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterSetup()
        setupNavigation()
        setupEventData()
        venuImageView.layer.cornerRadius = 10.0
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChange(notification:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }

    @objc func orientationChange(notification: Notification) {
        self.titleHeightConstraint.constant = self.headerTitle.estimatedHeightOfLabel()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    /// Function to setup presenter
    private func presenterSetup() {
        self.presenter = DetailPresenter(view: self)
    }

    /// Function to setup navigation
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        favouriteButton.setImage(UIImage.alwaysRendering(named: "favourite"), for: .normal)
        backButton.setImage(UIImage.alwaysRendering(named: "back"), for: .normal)
    }

    /// Function to setup event data
    private func setupEventData() {
        if let model = event {
            if let imageUrl = model.imageUrl {
                self.venuImageView.kf.setImage(with: imageUrl)
            } else {
                self.venuImageView.image = #imageLiteral(resourceName: "placeholderIcon")
            }
            self.headerTitle.text = model.title()
            self.eventLocationLabel.text = "\(model.venue.city ?? ""), \(model.venue.state ?? "")"
            self.eventTimeLabel.text = model.utcDate.localizedDate
            self.titleHeightConstraint.constant = self.headerTitle.estimatedHeightOfLabel()
            self.isFavourite = DataManager.shared.isFavourite(eventId: model.id ?? "0")
        }
    }

    @IBAction func favouriteSelected(_ sender: Any) {
        self.isFavourite = !self.isFavourite
        if let eventId = event?.id {
            if self.isFavourite {
                DataManager.shared.save(favouriteEventId: eventId)
            } else {
                DataManager.shared.delete(favouriteEventId: eventId)
            }
        }
    }
}

extension DetailViewController: DetailPresenterProtocol {

}
