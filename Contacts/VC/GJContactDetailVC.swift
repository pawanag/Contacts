//
//  GJContactDetailVC.swift
//  Contacts
//
//  Created by Pawan on 22/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

enum GJContactDetailType {
    case mobile, email
    
    var title: String? {
        var title: String
        switch self {
        case .email:
            title = "email"
            
        case .mobile:
            title = "mobile"
        }
        return title
    }
}

class GJContactDetailVM {
    var contactId: Int
    var contactDetails: GJContact?
    var detailTypes: [GJContactDetailType] = [.email, .mobile]
    
    init(id: Int) {
        self.contactId = id
    }
}

class GJContactDetailVC: GJBaseVC {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    //MARK: Private Properies
    private var viewModel: GJContactDetailVM?
    private enum Constants {
        static let cellHeight: CGFloat = 65.0
        static let headerHeight: CGFloat = 30.0
    }
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        if let id = self.viewModel?.contactId {
            self.fetchDetails(of: id)
        }
    }
    
    //MARK: Internal Methods
    class func controller(contactId: Int) -> GJContactDetailVC? {
        let controller = GJBaseVC.storyboard.instantiateViewController(withIdentifier: "GJContactDetailVC") as? GJContactDetailVC
        controller?.viewModel = GJContactDetailVM(id: contactId)
        return controller
    }
}

private extension GJContactDetailVC {
    func fetchDetails(of contactId: Int) {
        GJAPIManager.shared.getContactDetails(of: contactId) { (response, error) in
            guard let contact = response as? GJContact else {
                //TODO:
                return
            }
            self.viewModel?.contactDetails = contact
            DispatchQueue.main.async {[weak self] in
                self?.configureUI()
                self?.tableView.reloadData()
            }
        }
    }
    
    func configureUI() {
        self.nameLabel.text = self.viewModel?.contactDetails?.name
        self.imageView.setImage(with: self.viewModel?.contactDetails?.profilePic)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GJContactDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.detailTypes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GJContactDetailTVC", for: indexPath) as! GJContactDetailTVC
        if let details = self.viewModel?.contactDetails, let type = self.viewModel?.detailTypes[indexPath.row] {
            cell.configure(with: details, type: type)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
