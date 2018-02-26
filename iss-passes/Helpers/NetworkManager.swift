//
//  NetworkManager.swift
//
//  Created by Cristian Aaron on 12/7/17.
//  Copyright © 2017 Cristian Aaron. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
  
  //Delegate variables, and result helper
  var delegate: NetworkManagerDelegate?
  var alert: NetworkManagerDelegateAlert?
  var results: [[String: Any]]?
  
  //Give an URL given parameters and with the existing default API settings
  func createURLFromParameters(parameters: [String:Any]) -> URL {
    var components = URLComponents()
    components.scheme = Helpers.APIDetails.APIScheme
    components.host   = Helpers.APIDetails.APIHost
    components.path = Helpers.APIDetails.APIParamPath
    
    //If the paramaters received has values then fetch with the URLComponent created
    if !parameters.isEmpty {
      components.queryItems = [URLQueryItem]()
      for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
      }
    }
    return components.url!
  }

  //Main function that is connected with a services that recive a parameters
  func downloadAPIPasses(parameters: [String: Any]){
    //Create the URL that it will be called
    let url = createURLFromParameters(parameters: parameters).absoluteURL
      let request = URLRequest(url: url)
      //Execute the url request
      let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
        //If there's an error in the request return to the viewcontroller with an alert that shows the error
        if error != nil {
          print(error as Any)
          self?.alert?.showAlert(message: "There was an error trying to request the passes with your params", title: "Oh oh", first: false)
        } else {
          //If there's no error, convert the data response to a JSON an then as Dictionary
          do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
              DispatchQueue.main.async {
                //If the Dictionary converted has a value on the position "response" return to the delegator with the correct value, else return an alert with the error, everything as an async task to don't overload the main thread
                if let passes = jsonArray["response"]  {
                  self?.delegate?.didDownloadPasses(passes: passes as! [[String: Any]])
                } else {
                  self?.alert?.showAlert(message: "There are no passes with the lat and lon specified", title: "Sorry", first: false)
                }
              }
            }
          } catch {
              print(error.localizedDescription)
          }
        }
      }
      task.resume()
    }
  
}


