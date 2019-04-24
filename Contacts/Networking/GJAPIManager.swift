//
//  GJAPIManager.swift
//  Contacts
//
//  Created by Pawan on 20/04/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class GJAPIManager {
    //MARK: Internal Properties
    static let shared = GJAPIManager()
    
    //MARK: Private Properties
    typealias GJResponseHandler = ((Any?, Error?)->())?
    
    //MARK: Internal Methods
    func getContacts(handler: GJResponseHandler) {
        let urlString = "http://gojek-contacts-app.herokuapp.com/contacts.json"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    do {
                        let contacts = try JSONDecoder().decode([GJContact].self, from: data)
                        handler?(contacts, nil)
                    } catch {
                        print("error: ", error.localizedDescription)
                        handler?(nil, error)
                    }
                }
            }.resume()
        }
    }
    
    func getContactDetails(of id: Int, handler: GJResponseHandler) {
        let urlString = "http://gojek-contacts-app.herokuapp.com/contacts/\(id).json"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    do {
                        let contacts = try JSONDecoder().decode(GJContact.self, from: data)
                        handler?(contacts, nil)
                    } catch {
                        print("error: ", error)
                        handler?(nil, error)
                    }
                }
            }.resume()
        }
    }
    
    func editContactDetails(contact: GJContact, handler: GJResponseHandler) {
        if let id = contact.id {
            let urlString = "http://gojek-contacts-app.herokuapp.com/contacts/\(id).json"
            if let url = URL(string: urlString), let data = try? JSONEncoder().encode(contact) {
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                    if let data = data {
                        do {
                            let contacts = try JSONDecoder().decode(GJContact.self, from: data)
                            handler?(contacts, nil)
                        } catch {
                            print("error: ", error.localizedDescription)
                            handler?(nil, error)
                        }
                    }
                    }.resume()
            }
        } else {
            handler?(nil, nil)
        }
    }
    
    func addContactDetails(contact: GJContact, handler: GJResponseHandler) {
        let urlString = "http://gojek-contacts-app.herokuapp.com/contacts.json"
        if let url = URL(string: urlString), let data = try? JSONEncoder().encode(contact) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                if let data = data {
                    do {
                        let contacts = try JSONDecoder().decode(GJContact.self, from: data)
                        handler?(contacts, nil)
                    } catch {
                        print("error: ", error.localizedDescription)
                        handler?(nil, error)
                    }
                }
                }.resume()
        }
    }
    
    func downloadImage(from urlString: String?, handler: GJResponseHandler) {
        if let urlString = urlString, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    handler?(image, nil)
                } else {
                    handler?(nil, nil)
                }
            }.resume()
        } else {
            handler?(nil, nil)
        }
    }
}
