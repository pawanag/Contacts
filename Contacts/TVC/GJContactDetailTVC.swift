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
    @IBOutlet weak var textField: UITextField!
    
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
        self.textField.text = nil
    }
    
    //MARK: Internal Methods
    func configure(with title: String?, value: String?, isEditable: Bool) {
        self.titleLabel.text = title
        self.textField.text = value
        self.textField.isUserInteractionEnabled = isEditable
    }
}
