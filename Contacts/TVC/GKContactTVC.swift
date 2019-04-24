//
//  GKContactTVC.swift
//  Contacts
//
//  Created by Pawan on 20/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GKContactTVC: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    //AMRK: Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCell()
    }
    
    //MARK: Private Methods
    private func resetCell() {
        self.profileImageView.image = #imageLiteral(resourceName: "placeholder_photo")
        self.nameLabel.text = nil
        self.favouriteImageView.isHidden = true
    }
    
    //MARK: Internal Methods
    func configure(with contact: GJContact) {
        self.nameLabel.text = contact.name
        if let isFavourite = contact.favourite {
            self.favouriteImageView.isHidden = !isFavourite
        }
        self.profileImageView.setImage(with: contact.profilePic)
    }
}
