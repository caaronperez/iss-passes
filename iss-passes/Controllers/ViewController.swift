//
//  ViewController.swift
//  iss-passes
//
//  Created by MCS Devices on 12/7/17.
//  Copyright © 2017 Mobile Consulting Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import ActionSheetPicker_3_0

class ViewController: UIViewController {

  //Help variables in this view
  let locationManager = CLLocationManager()
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var passesInput: UITextField!
  var location: CLLocationCoordinate2D!
  var networkRequests: [Any?] = []
  var passes: [[String: Any]] = []
  var nPasses: Int?
  
  //First call with functions separated to init the app
  override func viewDidLoad() {
    super.viewDidLoad()
    loadLocation()
    fillItems()
  }
  
  //Fill items at begginin in code as a best practice
  func fillItems() {
    subtitleLabel.text = "Change passes number"
    self.title = "International Space Station Passes"
  }
  
  //Load the location. If is not detected, means that the user doesn't allow the location, so the app thwrows an alert
  func loadLocation() {
    // Ask for Authorisation from the User.
    self.locationManager.requestAlwaysAuthorization()
    
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()
    
    //If the location is enabled, else throw an alert
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    } else {
      showAlert(message: "Enable location service for this app and try again", title: "Location problem", first: true)
    }
  }
  
  //Action from button if the user change the number of passes
  @IBAction func didPressOK(_ sender: UIButton) {
    if let passes = Int(passesInput.text!) {
      self.nPasses = passes
      callPasses()
    }
  }
}

extension ViewController: CLLocationManagerDelegate {
  
  //Func from delegate, called after the location service is executed, the location is assigned to a local variable
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let locValue:CLLocationCoordinate2D = manager.location!.coordinate
    location = locValue
    callPasses()
  }
  
  //Declare and init to the network service, assigning the return direction in delegate variable
  func callPasses() {
    let networkTest = NetworkManager()
    networkRequests.append(networkTest)
    networkTest.delegate = self
    networkTest.alert = self
    if nPasses != nil {
      networkTest.downloadAPIPasses(parameters: ["lat":location.latitude, "lon":location.longitude, "n":nPasses!])
    } else {
      networkTest.downloadAPIPasses(parameters: ["lat": location.latitude, "lon": location.longitude])
    }
  }
}

extension ViewController: NetworkManagerDelegate {
  //Function called by Network Manager, after download the passes with the given lon and lat, reloading the table view at the end
  func didDownloadPasses(passes: [[String : Any]]) {
    self.passes = passes
    tableView.reloadData()
  }
}

extension ViewController: UITableViewDataSource {
  
  //Fill the table with the total of passes on the local variable "passes", other way is making with sections
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return passes.count
  }
  
  //Fill each cell, calling first the name, and give format, and fill the elements inside with the indexPath
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell", for: indexPath) as! PassCellController
    
    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.91, alpha:1.0)
    }
    
    cell.passNumber.text = "\(indexPath.row + 1)"
    
    if let duration = passes[indexPath.row][Helpers.APIEndPoints.duration] as? Double {
      cell.passDuration.text = "\(duration) seg."
    }
    
    if let date = passes[indexPath.row][Helpers.APIEndPoints.risetime] as? Double {
      cell.passDate.text = date.timestampToDateString()
    }
    return cell
  }

}

extension ViewController: UITextFieldDelegate {
  
  //Detect when the text field of number is pressed with the delegate option
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.passesInput.isHidden = false
    //Call to an extension of picker options as an additional functionality, to give a best user experience
      let acp = ActionSheetStringPicker(title: "Select number of passes", rows: Array(1...100), initialSelection: 0, doneBlock: {
        picker, values, indexes in
        if let i = indexes {
          self.passesInput.text = "\(i)"
      }
      return
    }, cancel: { ActionMultipleStringCancelBlock in return }, origin: textField)
    
    acp?.show()
    return false
  }
}

extension ViewController: NetworkManagerDelegateAlert {
  //Show alert, if the boolean option is true go to setting, else only show the alert that it can be created from another class
  func showAlert(message: String, title: String, first: Bool) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    if first {
      //If the message is referred to enable the location, create a link to phone settings to enable the location service
      let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
          return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
          UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            print("Settings opened: \(success)")
          })
        }
      }
      alertController.addAction(settingsAction)
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
      }))
    } else {
      //If is only a message create just the button OK to close
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
      }))
      
    }
    
    present(alertController, animated: true, completion: nil)
  }
}

