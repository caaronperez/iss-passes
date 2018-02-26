//
//  NetworkManager.swift
//
//  Created by Cristian Aaron on 12/7/17.
//  Copyright © 2017 Cristian Aaron. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkManagerDelegate: class {
  func didDownloadPasses(passes: [[String: Any]])
}

protocol NetworkManagerDelegateAlert: class {
  func showAlert(message: String, title: String, first: Bool)
}

