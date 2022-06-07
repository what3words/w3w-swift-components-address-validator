//
//  File.swift
//  
//
//  Created by Dave Duprey on 18/05/2022.
//

import Foundation
import UIKit
import CoreLocation
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftInterfaceElements
import W3WSwiftComponents
import W3WSwiftAddressValidators


// expose these types from the W3WSwiftAddressValidators dependancy
public typealias W3WStreetAddressProtocol = W3WSwiftAddressValidators.W3WStreetAddressProtocol
public typealias W3WStreetAddressGeneric  = W3WSwiftAddressValidators.W3WStreetAddressGeneric
public typealias W3WStreetAddressUK       = W3WSwiftAddressValidators.W3WStreetAddressUK
public typealias W3WCoreColor             = W3WSwiftDesign.W3WCoreColor
public typealias W3WColor                 = W3WSwiftDesign.W3WColor
public typealias W3WColorSet             = W3WSwiftDesign.W3WColorSet


public class W3WAddressValidatorViewController: UINavigationController, UINavigationControllerDelegate { //}, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

  // MARK: Callbacks
  
  /// called when the user chooses an address
  public var onAddressSelected: (W3WStreetAddressProtocol?) -> () = { _ in }
  
  /// called when there is an error
  public var onError: (W3WAddressValidatorComponentError) -> () = { _ in }

  // MARK: Vars
  
  // suggestion the user chose
  var suggestion: W3WSuggestion?
  
  // what3words api or sdk
  var w3w: W3WProtocolV3!
  
  // the api for the address validator
  var service: W3WAddressValidatorProtocol

  // the input text field
  var searchField: W3WAutoSuggestSearchController! // W3WSearchController!
  
  // default colors
  var colors = W3WColorSet.lightDarkMode
  
  // root view controller
  let rootViewController = W3WViewController()
  
  
  // MARK: Init
  
  
  public init(w3w: W3WProtocolV3, service: W3WAddressValidatorProtocol, colors: W3WColorSet = .lightDarkMode) {
    self.w3w = w3w
    self.service = service
    self.colors = colors
    
    super.init(rootViewController: rootViewController)
    self.delegate = self
  }
  
  
  public init(w3w: W3WProtocolV3, data8ApiKey: String, colors: W3WColorSet = .lightDarkMode) {
    self.w3w = w3w
    self.service = W3WAddressValidatorData8(key: data8ApiKey)
    self.colors = colors

    super.init(rootViewController: rootViewController)
    self.delegate = self
  }
  
  
  public init(w3w: W3WProtocolV3, swiftCompleteApiKey: String, colors: W3WColorSet = .lightDarkMode) {
    self.w3w = w3w
    self.service = W3WAddressValidatorSwiftComplete(key: swiftCompleteApiKey)
    self.colors = colors

    super.init(rootViewController: rootViewController)
    self.delegate = self
  }
  
  
  public init(w3w: W3WProtocolV3, loqateApiKey: String, colors: W3WColorSet = .lightDarkMode) {
    self.w3w = w3w
    self.service = W3WAddressValidatorLoqate(w3w: w3w, key: loqateApiKey)
    self.colors = colors

    super.init(rootViewController: rootViewController)
    self.delegate = self
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Accessors

  
  public func set(display: String) {
    if w3w.isPossible3wa(text: display) {
      w3w.autosuggest(text: display) { suggestions, error in
        if let suggestion = suggestions?.first {
          DispatchQueue.main.async {
            self.searchField.set(display: suggestion)
          }
        }
      }
    }
  }
  
  
  // MARK: viewDidLoad
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    // give the tableview to the searchfield
    searchField = W3WAutoSuggestSearchController()
    searchField.set(w3w)
    searchField.set(voice: true)
    rootViewController.navigationItem.searchController = searchField
    searchField.automaticallyShowsCancelButton = false
    
    self.additionalSafeAreaInsets = UIEdgeInsets(top: W3WPadding.bold.value + W3WPadding.thin.value, left: 0.0, bottom: 0.0, right: 0.0)
    
    // tell searchfield what to do when a user selects an address
    searchField.onSuggestionSelected = { suggestion in
      self.userSelected(suggestion: suggestion)
    }
    
    searchField.definesPresentationContext = true
    searchField.searchBar.sizeToFit()
    
    updateColors()
  }


  /// make the searchbar become active on launch
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    self.searchField.isActive = true
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//      self.searchField.searchBar.becomeFirstResponder()
//    }
  }

  
  // MARK: takin' care o' bidness (business logic)
  
  
  /// called when the user selects a suggestion
  func userSelected(suggestion: W3WSuggestion) {
    self.suggestion = suggestion
    
    if let words = suggestion.words {
      let nextView = showAndReturnAddressView()

      service.search(near: words) { addresses, error in
        self.dealWithErrorIfAny(error: error)
        //self.showNextView(addresses: addresses)
        nextView.set(items: addresses)
      }
    }
  }
  
  
  func userSelected(address: W3WValidatorNode) {

    // if the user chose an address leaf
    if let a = address as? W3WValidatorNodeLeaf {
      if let s = suggestion {
        self.showSummaryView(suggestion: s, address: a)
      } else {
        self.dealWithErrorIfAny(error: W3WAddressValidatorComponentError.internalInconsistancy)
      }

    // if the user chose an item that leads to a list
    } else {
      let nextView = showAndReturnAddressView()
      
      // if the user selected a what3words suggestion
      if let a = address as? W3WValidatorNodeSuggestion {
        if let words = a.words {
          service.search(near: words) { addresses, error in
            self.dealWithErrorIfAny(error: error)
            nextView.set(items: addresses)
            //self.showNextView(addresses: addresses)
          }
        }
        
      // else the user chose an address suggestion
      } else if let a = address as? W3WValidatorNodeList {
        service.list(from: a) { addresses, error in
          self.dealWithErrorIfAny(error: error)
          nextView.set(items: addresses)
          //self.showNextView(addresses: addresses)
        }
      }
    }
  }
  
  
  func userChose(address: W3WValidatorNodeLeaf) {
    service.info(for: address) { address, error in
      self.dealWithErrorIfAny(error: error)
      
      DispatchQueue.main.async {
        self.onAddressSelected(address?.address)
        self.dismiss(animated: true)
      }
    }
  }
  
  
  // MARK: Show Views
  

  func showAndReturnAddressView() -> W3WAddressValidatorTableViewController {
    let addressValidatorViewController = W3WAddressValidatorTableViewController()
    
    // tell address what to do when a user selects a suggestion
    addressValidatorViewController.onRowSelected = { address, indexPath in
      self.userSelected(address: address)
    }
    
    DispatchQueue.main.async {
      print("PUSHING CONTROLLER")
      self.pushViewController(addressValidatorViewController, animated: true)
    }
    
    return addressValidatorViewController
  }
  
  
  func showNextView(addresses: [W3WValidatorNode]) {
    DispatchQueue.main.async {

      // make the tableview
      let addressValidatorViewController = W3WAddressValidatorTableViewController()
      addressValidatorViewController.colors = self.colors
      addressValidatorViewController.set(noResultsMessage: "No Results")

      // give it the rows data
      addressValidatorViewController.set(items: addresses)
      
      // tell address what to do when a user selects a suggestion
      addressValidatorViewController.onRowSelected = { address, indexPath in
        self.userSelected(address: address)
      }

      //self.show(addressValidatorViewController, sender: self)
      self.pushViewController(addressValidatorViewController, animated: true)
    }
  }
  
  
  func showSummaryView(suggestion: W3WSuggestion, address: W3WValidatorNodeLeaf) {
    let vc = W3WAddressValidatorSummayView(suggestion: suggestion, address: address)
    
    vc.onConfirm = { address in
      self.userChose(address: address)
    }
    
    self.pushViewController(vc, animated: true)
  }
  
  
  /// respond to dark/light mode updates
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColors()
    view.setNeedsDisplay()
  }
  
  
  func updateColors() {
    rootViewController.view.layer.backgroundColor = colors.background.current.cgColor
    //navigationController?.view.backgroundColor = colors.background.current.uiColor
    //navigationController?.navigationBar.backgroundColor = colors.background.current.uiColor
    view.backgroundColor = colors.background.current.uiColor
    view.layer.backgroundColor = colors.background.current.cgColor
    view.layer.borderColor = colors.background.current.cgColor
  }
  
  
  // MARK: Errors
  
  
  func dealWithErrorIfAny(error: W3WAddressValidatorError?) {
    if let e = error {
      dealWithErrorIfAny(error: W3WAddressValidatorComponentError.addressValidator(error: e))
    }
  }

  
  func dealWithErrorIfAny(error: W3WAddressValidatorComponentError?) {
    if let e = error {
      onError(e)
    }
  }
  
}





