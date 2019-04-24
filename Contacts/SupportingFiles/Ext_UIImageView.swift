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
        GJAPIManager.shared.downloadImage(from: urlString) {[weak self] (response, error) in
            DispatchQueue.main.async {
                if let image = response as? UIImage {
                    self?.image = image
                } else {
                    self?.image = #imageLiteral(resourceName: "placeholder_photo")
                }
            }
        }
    }
}
