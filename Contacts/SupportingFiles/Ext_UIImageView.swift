//
//  Ext_UIImageView.swift
//  Contacts
//
//  Created by Pawan on 22/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(with urlString: String?) {
        GJAPIManager.shared.downloadImage(from: urlString) { (response, error) in
            DispatchQueue.main.async {
                self.image = response as? UIImage
            }
        }
    }
}
