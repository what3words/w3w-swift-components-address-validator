//
//  ViewController.swift
//  iOSAddressValidator
//
//  Created by Dave Duprey on 22/08/2022.
//

import UIKit
import CoreLocation
import W3WSwiftApi
import W3WSwiftComponentsAddressValidator


class ViewController: UIViewController {

  let apiKey = "YourWhat3wordsApiKey"
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let api  = What3WordsV3(apiKey: apiKey)
    let swiftCompleteApiKey = "YourSwiftCompleteApiKey" // this component also supports Loqate and Data8
    
    let validator = W3WAddressValidatorViewController(w3w: api, swiftCompleteApiKey: swiftCompleteApiKey) // for Loqate and Data8, change the second parameter and it's label appropriately
    
    // set the focus to a nearby location
    let options = W3WOptions().focus(CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337))
    validator.set(options: options)
    
    // closure for when the address has been selected by the user
    validator.onAddressSelected = { address in
      self.notify(title: "Address", message: address?.description ?? "Unknown", dismissing: validator)
    }

    // on error, notify the user with an alert
    validator.onError = { error in
      self.notify(title: "Error", message: error.description, dismissing: validator)
    }

    // present the view controller
    DispatchQueue.main.async {
      self.show(validator, sender: self)
    }
  }

  
  
  // MARK: - Popup Message
  
  
  func notify(title: String, message: String, dismissing: UIViewController) {
    DispatchQueue.main.async {
      dismissing.dismiss(animated: true) {
        let note = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        note.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in }))
        self.present(note, animated: true) { }
      }
    }
  }
  

}

