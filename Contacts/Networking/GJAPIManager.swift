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
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        handler?(nil, nil)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        handler?(nil, nil)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        handler?(nil, nil)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        handler?(nil, nil)
                    } catch {
                        print("error: ", error)
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
