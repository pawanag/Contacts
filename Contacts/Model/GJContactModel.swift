//
//  GJContactModel.swift
//  Contacts
//
//  Created by Pawan on 20/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GJContact: Decodable {
    var id: Int
    var firstName: String?
    var lastName: String?
    var profilePic: String?
    var favourite: Bool?
    var url: String?
    var email: String?
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case id, favourite, url, email
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case phoneNumber = "phone_number"
    }
    
    var name: String? {
        var text = self.firstName ?? ""
        if let lName = self.lastName {
            text += " " + lName
        }
        return text
    }
    
    var profileImage: UIImage? {
        if let profilePic = self.profilePic, !profilePic.isEmpty {
            let image = UIImage(contentsOfFile: profilePic)
            return image
        }
        return nil
    }
    
}
