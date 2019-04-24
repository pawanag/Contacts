//
//  GJBaseVC.swift
//  Contacts
//
//  Created by Pawan on 22/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GJBaseVC: UIViewController {
    static let storyboard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
