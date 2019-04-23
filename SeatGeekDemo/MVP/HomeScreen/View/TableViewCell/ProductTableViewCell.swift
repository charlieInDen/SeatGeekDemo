//
//  ProductTableViewCell.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    // MARK: - Properties

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImageView.layer.cornerRadius = 10.0
        productImageView.clipsToBounds = true
        favouriteIcon.image = UIImage.alwaysRendering(named: "favourite")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// Function to set data in cells
    /// - Parameters:
    ///   - indexPath: takes event model as input
    func setupData(model: SGEvent) {
        if let imageURL = model.imageUrl {
            self.productImageView.kf.setImage(with: imageURL)
        } else {
            self.productImageView.image = #imageLiteral(resourceName: "placeholderIcon")
        }
        self.titleLabel.text = model.title()
        self.locationLabel.text = "\(model.venue.city ?? ""), \(model.venue.state ?? "")"
        self.dateLabel.text = model.utcDate.localizedDate
        self.favouriteIcon.isHidden = !DataManager.shared.isFavourite(eventId: model.id ?? "0")
    }

    class var height: CGFloat {
        return 100.0
    }
}
