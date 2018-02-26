//
//  Helpers.swift
//
//  Created by Cristian Aaron on 12/7/17.
//  Copyright © 2017 Cristian Aaron. All rights reserved.
//

import UIKit

class Helpers: NSObject {
  
  //API Details necessary to connect with the correct URL and make it more stable
  struct APIDetails {
    static let APIScheme = "http"
    static let APIHost = "api.open-notify.org"
    static let APIParamPath =  "/iss-pass.json"
  }
  
  //API EndPoints with the default parameters
  struct APIEndPoints {
    static let response = "response"
    static let duration = "duration"
    static let risetime = "risetime"
  }
  
}

//Extension of double class to convert a timestamp to a date formatted with the local time in a string as one of the best ways
extension Double {
  func timestampToDateString() -> String {
    //The same number convert to a date with the init default function from the class Date
    let date = Date(timeIntervalSince1970: self)
    //Create a date formatter, give the current local timezone, and format to convert (it can be complete, short, or medium)
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.locale = Locale.current
    dayTimePeriodFormatter.timeZone = TimeZone.current
    dayTimePeriodFormatter.dateStyle = .long
    dayTimePeriodFormatter.timeStyle = .short
    //Convert the date created at the beggining in a string formatted with help of dayTimePeriodFormatter variable
    let dateString = dayTimePeriodFormatter.string(from: date)
    return dateString
  }
}


extension String {
  //Extension of a string to check if another string exist inside the given string
  func contains(find: String) -> Bool{
    return self.range(of: find) != nil
  }
  
  func containsIgnoringCase(find: String) -> Bool{
    return self.range(of: find, options: String.CompareOptions.caseInsensitive) != nil
  }
}
