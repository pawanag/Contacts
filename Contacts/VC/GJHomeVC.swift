//
//  GJHomeVC.swift
//  Contacts
//
//  Created by Pawan on 20/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GKHomeVM {
    var contacts: [[GJContact]]?
    
    func numberOfSections() -> Int {
        return self.contacts?.count ?? 0
    }
    
    func numberOfContacts(in section: Int) -> Int {
        return self.contacts?[section].count ?? 0
    }
    
    func contact(at indexPath: IndexPath) -> GJContact? {
        return self.contacts?[indexPath.section][indexPath.row]
    }
}

class GJHomeVC: GJBaseVC {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Private Properies
    private let viewModel = GKHomeVM()
    private enum Constants {
        static let cellHeight: CGFloat = 65.0
        static let headerHeight: CGFloat = 30.0
    }
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.fetchContacts()
    }
}

// MARK: - Button Action Methods
extension GJHomeVC {
    @IBAction func onTapAddContactButton(_ sender: UIBarButtonItem) {
        self.openDetail(source: .add)
    }
}

// MARK: - Private Methods
private extension GJHomeVC {
    func fetchContacts() {
        self.activityIndicator.startAnimating()
        GJAPIManager.shared.getContacts { (response, error) in
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
                guard let contacts = response as? [GJContact] else {
                    //TODO:
                    return
                }
                if let groupedContacts = self?.getGroupedContacts(from: contacts) {
                    self?.viewModel.contacts = groupedContacts
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func getGroupedContacts(from contacts: [GJContact]) -> [[GJContact]]? {
        let groupedContacts = Dictionary(grouping: contacts) { $0.firstName?.first }
        return Array(groupedContacts.values).sorted(by: { (sec0, sec1) -> Bool in
            if let fName0 = sec0.first?.firstName, let fName1 = sec1.first?.firstName {
                return fName0 < fName1
            }
            return false
        })
    }
    
    func openDetail(source: GJContactDetailSource) {
        if let controller = GJContactDetailVC.controller(source: source) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GJHomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfContacts(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GKContactTVC", for: indexPath) as! GKContactTVC
        if let contact = self.viewModel.contact(at: indexPath) {
            cell.configure(with: contact)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionName = self.viewModel.contacts?[section].first?.firstName?.first {
            let view = Bundle.main.loadNibNamed("GJHeaderView", owner: self, options: nil)?.first as? GJHeaderView
            view?.configure(with: String(sectionName))
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contactId = self.viewModel.contact(at: indexPath)?.id {
            self.openDetail(source: .view(contactId))
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
