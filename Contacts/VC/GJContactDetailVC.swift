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
    var contactDetails: GJContact?
    
    init(contactId: Int?) {
        self.contactId = contactId
    }
    
    func detailTypes(for source: GJContactDetailSource) -> [GJContactDetailType] {
        var detailTypes: [GJContactDetailType]
        switch source {
        case .view:
            detailTypes = [.email, .mobile]
            
        case .add, .edit:
            detailTypes = [.firstName, .lastName, .email, .mobile]
        }
        return detailTypes
    }
    
}

enum GJContactDetailSource {
    case view
    case edit
    case add
}

class GJContactDetailVC: GJBaseVC {
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButtonsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var isFavouriteImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    //MARK: Private Properies
    private var viewModel: GJContactDetailVM?
    private var source = GJContactDetailSource.view
    private enum Constants {
        static let cellHeight: CGFloat = 65.0
        static let headerHeight: CGFloat = 30.0
    }
    lazy var rightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(GJContactDetailVC.onTapEditContactDetailsButton(_:)))
        return barButton
    }()
    
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.addKeyboardNotifications()
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        switch source {
        case .view:
            self.rightBarButton.title = "Edit"
            
        case .add, .edit:
            self.rightBarButton.title = "Done"
            self.firstNameTextField.becomeFirstResponder()
        }
        if let id = self.viewModel?.contactId {
            self.fetchDetails(of: id)
        }
    }
    
    //MARK: Internal Methods
    class func controller(source: GJContactDetailSource, contactId: Int?) -> GJContactDetailVC? {
        let controller = GJBaseVC.storyboard.instantiateViewController(withIdentifier: "GJContactDetailVC") as? GJContactDetailVC
        controller?.source = source
        controller?.viewModel = GJContactDetailVM(contactId: contactId)
        return controller
    }
    
    @objc func onTapEditContactDetailsButton(_ sender: UIBarButtonItem) {
        switch source {
        case .view:
            sender.title = "Done"
            self.source = .edit
            self.configureUI()
            self.firstNameTextField.becomeFirstResponder()
            
        case .edit:
            self.view.endEditing(true)
            if let contact = self.viewModel?.contactDetails {
                contact.firstName = self.firstNameTextField.text
                contact.lastName = self.lastNameTextField.text
                contact.phoneNumber = self.mobileTextField.text
                contact.email = self.emailTextField.text
                self.editDetails(of: contact, handler: {(success) in
                    if success {
                        DispatchQueue.main.async {[weak self] in
                            sender.title = "Edit"
                            self?.source = .view
                            self?.configureUI()
                        }
                    }
                })
            }
            
        case .add:
            let contact = GJContact()
            contact.firstName = self.firstNameTextField.text
            contact.lastName = self.lastNameTextField.text
            contact.phoneNumber = self.mobileTextField.text
            contact.email = self.emailTextField.text
            self.addDetails(of: contact, handler: {(success) in
                if success {
                    DispatchQueue.main.async {[weak self] in
                        self?.source = .view
                        self?.configureUI()
                    }
                }
            })
        }
    }
}

private extension GJContactDetailVC {
    func fetchDetails(of contactId: Int) {
        self.activityIndicator.startAnimating()
        GJAPIManager.shared.getContactDetails(of: contactId) { (response, error) in
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
                let contact = response as? GJContact
                guard contact?.errors == nil else {
                    self?.showAlert(with: contact?.errors?.first)
                    return
                }
                self?.viewModel?.contactDetails = contact
                self?.configureUI()
            }
        }
    }
    
    func editDetails(of contact: GJContact, handler: ((Bool)->())?) {
        self.activityIndicator.startAnimating()
        GJAPIManager.shared.editContactDetails(contact: contact) { (response, error) in
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
                let contact = response as? GJContact
                guard contact?.errors == nil else {
                    self?.showAlert(with: contact?.errors?.first)
                    return
                }
                self?.viewModel?.contactDetails = contact
                self?.configureUI()
                handler?(true)
            }
        }
    }
    
    func addDetails(of contact: GJContact, handler: ((Bool)->())?) {
        self.activityIndicator.startAnimating()
        GJAPIManager.shared.addContactDetails(contact: contact) { (response, error) in
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
                let contact = response as? GJContact
                guard contact?.errors == nil else {
                    self?.showAlert(with: contact?.errors?.first)
                    return
                }
                self?.viewModel?.contactDetails = contact
                self?.configureUI()
                handler?(true)
            }
        }
    }
    
    func showAlert(with message: String?) {
        let alertVC = UIAlertController(title: "Error..!!!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func configureUI() {
        self.nameLabel.text = self.viewModel?.contactDetails?.name
        self.imageView.setImage(with: self.viewModel?.contactDetails?.profilePic)
        self.cameraButton.isHidden = (self.source == .view)
        self.isFavouriteImageView.image = (self.viewModel?.contactDetails?.favourite ?? false) ? #imageLiteral(resourceName: "favourite_button_selected") : #imageLiteral(resourceName: "favourite_button")
        self.actionButtonsStackViewHeightConstraint.constant = (self.source == .view) ? 64.0 : 0.0
        
        self.firstNameTextField.text = self.viewModel?.contactDetails?.firstName
        self.lastNameTextField.text = self.viewModel?.contactDetails?.lastName
        self.mobileTextField.text = self.viewModel?.contactDetails?.phoneNumber
        self.emailTextField.text = self.viewModel?.contactDetails?.email
        
        switch self.source {
        case .add, .edit:
            self.firstNameView.isHidden = false
            self.lastNameView.isHidden = false
            self.mobileTextField.isUserInteractionEnabled = true
            self.emailTextField.isUserInteractionEnabled = true

        case .view:
            self.firstNameView.isHidden = true
            self.lastNameView.isHidden = true
            self.mobileTextField.isUserInteractionEnabled = false
            self.emailTextField.isUserInteractionEnabled = false
        }

        self.view.layoutIfNeeded()
    }
}

// MARK: - Keyboard notification handling
private extension GJContactDetailVC {
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(notification: Notification) {
        if var keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject?)?.cgRectValue?.size.height {
            if UIScreen.main.bounds.height >= 812.0 {
                keyBoardHeight -= 34.0
            }
            self.bottomConstraint.constant = keyBoardHeight + 10.0
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillhide(notification: Notification) {
        self.bottomConstraint.constant = 10
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
}
