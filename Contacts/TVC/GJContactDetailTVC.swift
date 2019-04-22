//
//  GJContactDetailTVC.swift
//  Contacts
//
//  Created by Pawan on 22/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GJContactDetailTVC: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

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
        self.titleLabel.text = nil
        self.valueLabel.text = nil
    }
    
    //MARK: Internal Methods
    func configure(with contact: GJContact, type: GJContactDetailType) {
        self.titleLabel.text = type.title
        switch type {
        case .email:
            self.valueLabel.text = contact.email
            
        case .mobile:
            self.valueLabel.text = contact.phoneNumber
        }
    }
}
