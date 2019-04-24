//
//  GJContactDetailVC.swift
//  Contacts
//
//  Created by Pawan on 22/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

enum GJContactDetailType {
    case mobile, email, firstName, lastName
    
    var title: String? {
        var title: String
        switch self {
        case .email:
            title = "email"
            
        case .mobile:
            title = "mobile"
            
        case .firstName:
            title = "First Name"
            
        case .lastName:
            title = "Last Name"
        }
        return title
    }
}

class GJContactDetailVM {
    var contactId: Int?
    var detailTypes: [GJContactDetailType]
    var contactDetails: GJContact?
    var isEditable = false
    
    
    init(source: GJContactDetailSource) {
        switch source {
        case .view(let contactId):
            detailTypes = [.email, .mobile]
            self.contactId = contactId
            self.isEditable = false
            
        case .edit(let contactId):
            detailTypes = [.firstName, .lastName, .email, .mobile]
            self.contactId = contactId
            self.isEditable = true

        case .add:
            detailTypes = [.firstName, .lastName, .email, .mobile]
            self.isEditable = true
        }
    }
}

enum GJContactDetailSource {
    case view(Int)
    case edit(Int)
    case add
}

class GJContactDetailVC: GJBaseVC {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButtonsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var isFavouriteImageView: UIImageView!
    
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
        self.tableView.separatorColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.configureUI()
        if let id = self.viewModel?.contactId {
            self.fetchDetails(of: id)
        }
    }
    
    //MARK: Internal Methods
    class func controller(source: GJContactDetailSource) -> GJContactDetailVC? {
        let controller = GJBaseVC.storyboard.instantiateViewController(withIdentifier: "GJContactDetailVC") as? GJContactDetailVC
        controller?.viewModel = GJContactDetailVM(source: source)
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
        self.cameraButton.isHidden = !(self.viewModel?.isEditable ?? false)
        self.isFavouriteImageView.image = (self.viewModel?.contactDetails?.favourite ?? false) ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button")
        self.actionButtonsStackViewHeightConstraint.constant = (self.viewModel?.isEditable ?? false) ? 0.0 : 64.0
        self.view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GJContactDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.detailTypes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GJContactDetailTVC", for: indexPath) as! GJContactDetailTVC
        if let type = self.viewModel?.detailTypes[indexPath.row] {
            var value: String?
            switch type {
            case .email:
                value = self.viewModel?.contactDetails?.email
                
            case .mobile:
                value = self.viewModel?.contactDetails?.phoneNumber
                
            default:
                break
            }
            cell.configure(with: type.title, value: value, isEditable: self.viewModel?.isEditable ?? false)
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
