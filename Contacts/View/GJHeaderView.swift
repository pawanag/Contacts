//
//  GJHeaderView.swift
//  Contacts
//
//  Created by Pawan on 20/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GJHeaderView: UIView {
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = nil
    }
    
    //MARK: Internal Methods
    func configure(with title: String?) {
        self.titleLabel.text = title
    }
}
