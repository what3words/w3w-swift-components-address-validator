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
//import W3WSwiftComponentsInternal


// expose these types from the W3WSwiftAddressValidators dependancy
public typealias W3WStreetAddressProtocol = W3WSwiftAddressValidators.W3WStreetAddressProtocol
public typealias W3WStreetAddressGeneric  = W3WSwiftAddressValidators.W3WStreetAddressGeneric
public typealias W3WStreetAddressUK       = W3WSwiftAddressValidators.W3WStreetAddressUK
public typealias W3WCoreColor             = W3WSwiftDesign.W3WCoreColor
public typealias W3WColor                 = W3WSwiftDesign.W3WColor
public typealias W3WColorSet              = W3WSwiftDesign.W3WColorSet


open class W3WAddressValidatorViewController: UINavigationController, UINavigationControllerDelegate, W3WOptionAcceptorProtocol {

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
  
  /// this communicates with the w3w server
  var autosuggest: W3WAutosuggestHelper!
  
  /// options to use for autosuggest
  var options: [W3WOption]?
  
  // langauge code to use for voice input
  var voiceInputLanguage = "en"
  
  // the api for the address validator
  var service: W3WAddressValidatorProtocol

  // the input text field
  public var searchField: W3WSearchController! // W3WAutoSearchController! // W3WAutoSuggestSearchController! //
  
  // default colors
  var colors = W3WColorSet.lightDarkMode
  
  // mode to launch in:  voice or text
  var launchMode = W3WAddressValidatorLaunchMode.text
  
  // root view controller
  let rootViewController = W3WViewController()

  // the input voice view
  var voiceViewController: W3WVoiceViewController?
  
  // the table view that holds the suggestions
  let addressValidatorTableViewController = W3WAddressValidatorTableViewController()

  // allows or disables a final address confirmation screen
  public var skipConfirmStep = false
  
  //
  public var showSuggestionsAfterVoiceInput = false
  
  
  // MARK: Init
  
  
  /// initialize with a address validator service
  /// - Parameters:
  ///     - w3w: the w3w API or SDK
  ///     - service: a street address validator service conforming to W3WAddressValidatorProtocol
  ///     - colors: A W3WColorSet specifying the colours to use (optional)
  ///     - launchMode: tells the component to launch directly into voice or text mode
  public init(w3w: W3WProtocolV3, service: W3WAddressValidatorProtocol, colors: W3WColorSet = .lightDarkMode, launchMode: W3WAddressValidatorLaunchMode = .text) {
    self.launchMode = launchMode

    // if the API was passed in, then we use a copy.  This keeps all the custom headers unique to this object
    if let api = w3w as? What3WordsV3 {
      self.w3w = api.copy(api: api)
    } else {
      self.w3w = w3w
    }
    
    self.colors = colors
    self.autosuggest = W3WAutosuggestHelper(self.w3w)
    if let api = self.w3w as? What3WordsV3 {
      self.voiceViewController = W3WVoiceViewController(api: api)
    }
    self.service = service
    super.init(rootViewController: launchMode == .voice ? voiceViewController ?? rootViewController : rootViewController)
    self.setHeaders()
    self.delegate = self
    
//    let handle = W3WHandleIndicator(frame: .w3wWhatever)
//    navigationController?.navigationBar.addSubview(handle)
//    handle.position()
  }
  
  
  /// initialize with a Data8
  /// - Parameters:
  ///     - w3w: the w3w API or SDK
  ///     - data8ApiKey: you API key for Data8
  ///     - colors: A W3WColorSet specifying the colours to use (optional)
  ///     - launchMode: tells the component to launch directly into voice or text mode
  public init(w3w: W3WProtocolV3, data8ApiKey: String, colors: W3WColorSet = .lightDarkMode, launchMode: W3WAddressValidatorLaunchMode = .text) {
    self.launchMode = launchMode

    // if the API was passed in, then we use a copy.  This keeps all the custom headers unique to this object
    if let api = w3w as? What3WordsV3 {
      self.w3w = api.copy(api: api)
    } else {
      self.w3w = w3w
    }
    
    self.colors = colors
    self.autosuggest = W3WAutosuggestHelper(self.w3w)
    if let api = self.w3w as? What3WordsV3 {
      self.voiceViewController = W3WVoiceViewController(api: api)
    }
    self.service = W3WAddressValidatorData8(key: data8ApiKey)
    super.init(rootViewController: launchMode == .voice ? voiceViewController ?? rootViewController : rootViewController)
    self.setHeaders()
    self.delegate = self
  }
  
  
  /// initialize with a Swift Complete
  /// - Parameters:
  ///     - w3w: the w3w API or SDK
  ///     - swiftCompleteApiKey: you API key for Swift Complete
  ///     - colors: A W3WColorSet specifying the colours to use (optional)
  ///     - launchMode: tells the component to launch directly into voice or text mode
  public init(w3w: W3WProtocolV3, swiftCompleteApiKey: String, colors: W3WColorSet = .lightDarkMode, launchMode: W3WAddressValidatorLaunchMode = .text) {
    self.launchMode = launchMode

    // if the API was passed in, then we use a copy.  This keeps all the custom headers unique to this object
    if let api = w3w as? What3WordsV3 {
      self.w3w = api.copy(api: api)
    } else {
      self.w3w = w3w
    }
    
    self.colors = colors
    self.autosuggest = W3WAutosuggestHelper(self.w3w)
    if let api = self.w3w as? What3WordsV3 {
      self.voiceViewController = W3WVoiceViewController(api: api)
    }
    self.service = W3WAddressValidatorSwiftComplete(key: swiftCompleteApiKey)
    super.init(rootViewController: launchMode == .voice ? voiceViewController ?? rootViewController : rootViewController)
    self.setHeaders()
    self.delegate = self
  }
  
  
  /// initialize with a Loqate
  /// - Parameters:
  ///     - w3w: the w3w API or SDK
  ///     - loqateApiKey: you API key for Loqate
  ///     - colors: A W3WColorSet specifying the colours to use (optional)
  ///     - launchMode: tells the component to launch directly into voice or text mode
  public init(w3w: W3WProtocolV3, loqateApiKey: String, colors: W3WColorSet = .lightDarkMode, launchMode: W3WAddressValidatorLaunchMode = .text) {
    self.launchMode = launchMode

    // if the API was passed in, then we use a copy.  This keeps all the custom headers unique to this object
    if let api = w3w as? What3WordsV3 {
      self.w3w = api.copy(api: api)
    } else {
      self.w3w = w3w
    }

    self.colors = colors
    self.autosuggest = W3WAutosuggestHelper(self.w3w)
    if let api = self.w3w as? What3WordsV3 {
      self.voiceViewController = W3WVoiceViewController(api: api)
    }
    self.service = W3WAddressValidatorLoqate(w3w: w3w, key: loqateApiKey)
    super.init(rootViewController: launchMode == .voice ? voiceViewController ?? rootViewController : rootViewController)
    self.setHeaders()
    self.delegate = self
  }
  
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// common configuration for all init calls
//  func config(w3w: W3WProtocolV3, colors: W3WColorSet = .lightDarkMode, launchMode: W3WAddressValidatorLaunchMode = .text) {
//    self.launchMode = launchMode
//
//    // if the API was passed in, then we use a copy.  This keeps all the custom headers unique to this object
//    if let api = w3w as? What3WordsV3 {
//      self.w3w = api.copy(api: api)
//    } else {
//      self.w3w = w3w
//    }
//
//    self.colors = colors
//    self.autosuggest = W3WAutosuggestHelper(w3w)
//
//    // if the API was used, then we set up voice
//    if let api = w3w as? What3WordsV3 {
//      self.voiceViewController = W3WVoiceViewController(api: api)
//    }
//
//    // if the API was used, then we set up custom headers
//    if let api = w3w as? What3WordsV3 {
//      api.updateHeader(key: W3WSettings.addresssValidatorHttpHeaderKey, value: api.getHeaderValue(version: W3WSettings.W3WSwiftComponentsAddressValidatorVersion))
//    }
//
//    // init all the other member variables
//    self.delegate = self
//  }
  
  
  
  func setHeaders() {
    if let api = w3w as? What3WordsV3 {
      api.updateHeader(key: W3WSettings.addresssValidatorHttpHeaderKey, value: api.getHeaderValue(version: W3WSettings.W3WSwiftComponentsAddressValidatorVersion))
    }
  }
  
  
  // MARK: Accessors

  
  /// set the options to use in autosuggest calls
  public func set(options: [W3WOption]) {
    self.options = options
    voiceViewController?.set(options: options)
  }
  

  /// set the sugggestions to show
  public func set(suggestions: [W3WSuggestion]) {
    if suggestions.count == 1 {
      if let words = suggestions.first?.words {
        self.suggestion = suggestions.first
        self.service.search(near: words) { addresses, error in
          if let e = error {
            self.dealWith(error: e)
          } else {
            self.addressValidatorTableViewController.set(items: addresses)
          }
        }
        return
      }
    }

    autosuggest.suggestions = suggestions
    addressValidatorTableViewController.set(items: suggestionsToNodes(suggestions: suggestions))
  }
  
  
  // MARK: viewDidLoad
  
  
  open override func viewDidLoad() {
    super.viewDidLoad()

    // show the voice or text mode
    if let api = w3w as? What3WordsV3, launchMode == .voice {
      showVoiceEntryMode(api: api)
    } else {
      showTextEntryMode()
    }
    
    // tell address what to do when a user selects a suggestion
    addressValidatorTableViewController.onRowSelected = { [weak self] address, indexPath in
      self?.userSelected(address: address)
//      if let a = address as? W3WValidatorNodeSuggestion {
//        self?.suggestion = a.suggestion
//      }
    }

    // when the voice input returns suggestions, do a address search
    voiceViewController?.onSuggestions = { suggestions in
      if self.showSuggestionsAfterVoiceInput {
        self.userSelected(suggestions: suggestions)
        
      } else if let suggestion = suggestions.first {
        self.userSelected(suggestion: suggestion)
        
      } else {
        self.voiceViewController?.update(state: .error)
      }
    }
    
    updateColors()
  }
    

  
  /// show the voice entry mode and fall back to text entry if there is no voice capabilities
  func showVoiceEntryMode(api: What3WordsV3) {
    if let o = options {
      voiceViewController?.set(options: o)
    }
    
    // if voice is available this voiceViewController will not be nil
    if let vc = voiceViewController {
      navigationController?.setViewControllers([vc], animated: false)
    
    // if there is no voice capability the show text
    } else {
      showTextEntryMode()
    }
  }
    
  
  func instructionsFrame() -> CGRect {
    return CGRect(x: view.safeAreaInsets.left + W3WPadding.heavy.value, y: 128.0, width: view.frame.width - view.safeAreaInsets.right - W3WPadding.heavy.value * 2.0 - view.safeAreaInsets.left, height: 96.0)
  }
  
  
  /// show the text entry mode
  func showTextEntryMode() {
    // give the tableview to the searchfield
    searchField = W3WSearchController(searchResultsController: addressValidatorTableViewController)

    let instructions = UILabel(frame: .w3wWhatever)
    instructions.numberOfLines = 2
    instructions.text = "Search for any what3words address\ne.g. ///limit.broom.flip"
    instructions.textAlignment = .center
    instructions.textColor = colors.secondary.current.uiColor
    rootViewController.add(view: instructions, frame: instructionsFrame)
    
    // settings
    rootViewController.navigationItem.searchController = searchField
    searchField.automaticallyShowsCancelButton = false
    
    // padding
    self.additionalSafeAreaInsets = UIEdgeInsets(top: W3WPadding.bold.value + W3WPadding.thin.value, left: 0.0, bottom: 0.0, right: 0.0)
    
    // autosuggest called when there is a keystroke
    searchField.onTextChange = { [weak self] text in
      if self?.w3w.isPossible3wa(text: text) ?? false {
        self?.autosuggest.update(text: text, options: self?.options ?? []) { error in
          self?.addressValidatorTableViewController.set(items: self?.suggestionsToNodes(suggestions: self?.autosuggest.suggestions)  ?? [])
          //self?.addressValidatorTableViewController.highlight(match: { cell in cell.title == text })
        }
      } else {
        self?.set(suggestions: [])
      }
      
      return true
    }

    // settings
    searchField.definesPresentationContext = true
    searchField.searchBar.sizeToFit()
  }
  
  
  /// convert [W3WSuggestion] to [W3WValidatorNode]
  func suggestionsToNodes(suggestions: [W3WSuggestion]?) -> [W3WValidatorNode] {
    var nodes = [W3WValidatorNode]()
    
    for suggestion in suggestions ?? [] {
      nodes.append(W3WValidatorNodeSuggestion(suggestion: suggestion))
    }

    return nodes
  }
  

  /// make the searchbar become active on launch
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    self.searchField?.isActive = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.searchField?.searchBar.becomeFirstResponder()
    }
  }

  
  // MARK: takin' care o' bidness (business logic)
  
  
  /// called when the user selects a suggestion
  func userSelected(suggestion: W3WSuggestion) {
    self.suggestion = suggestion
    
    if let words = suggestion.words {
      let nextView = showAndReturnAddressView()

      service.search(near: words) { addresses, error in
        if let e = error {
          self.dealWith(error: e)
        } else {
          nextView.set(items: addresses)
        }
      }
    }
  }
  
  
  /// called when the user selects a suggestion
  func userSelected(suggestions: [W3WSuggestion]) {
    let nextView = showAndReturnAddressView()
    nextView.set(items: suggestionsToNodes(suggestions: suggestions))
  }

  
  /// called when the user selects an address
  func userSelected(address: W3WValidatorNode) {

    if let a = address as? W3WValidatorNodeSuggestion {
      self.suggestion = a.suggestion
    }

    // if the user chose an address leaf
    if let a = address as? W3WValidatorNodeLeaf {
      if let s = suggestion {
        if skipConfirmStep {
            self.userChose(address: a)
        } else {
          self.showSummaryView(suggestion: s, address: a)
        }
        
      } else {
        self.dealWith(error: W3WAddressValidatorComponentError.internalInconsistancy)
      }

    // if the user chose an item that leads to a list
    } else {
      let nextView = showAndReturnAddressView()
      
      // if the user selected a what3words suggestion
      if let a = address as? W3WValidatorNodeSuggestion {
        if let words = a.words {
          service.search(near: words) { addresses, error in
            if let e = error {
              self.dealWith(error: e)
            } else {
              nextView.set(items: addresses)
              self.setTitle(text: words, vc: nextView)
            }
          }
        }
        
      // else the user chose an address suggestion
      } else if let a = address as? W3WValidatorNodeList {
        service.list(from: a) { addresses, error in
          if let e = error {
            self.dealWith(error: e)
          } else {
            nextView.set(items: addresses)
            self.setTitle(text: a.name, vc: nextView)
          }
        }
      }
    }
  }
  

  // set the view controller title on the main thread
  func setTitle(text: String, vc: UIViewController) {
    DispatchQueue.main.async {
      vc.title = text
    }
  }
  
  
  // called when the user chooses an address
  func userChose(address: W3WValidatorNodeLeaf) {
    service.info(for: address) { address, error in
      DispatchQueue.main.async {
        if let e = error {
          self.dealWith(error: e)
          self.dismiss(animated: true)
        } else {
          DispatchQueue.main.async {
            self.onAddressSelected(address?.address)
            self.dismiss(animated: true)
          }
        }
      }
    }
  }
  
  
  // MARK: Show Views
  

  /// makes a new address view and returns it
  func showAndReturnAddressView() -> W3WAddressValidatorTableViewController {
    let addressValidatorViewController = W3WAddressValidatorTableViewController()

    addressValidatorViewController.set(noResultsMessage: "No results")
    
    // tell address what to do when a user selects a suggestion
    addressValidatorViewController.onRowSelected = { address, indexPath in
      self.userSelected(address: address)
    }
    
    DispatchQueue.main.async {
      self.pushViewController(addressValidatorViewController, animated: true)
    }
    
    return addressValidatorViewController
  }
  
  
  /// given some nodes show another view of them
//  func showNextView(addresses: [W3WValidatorNode]) {
//    DispatchQueue.main.async {
//
//      // make the tableview
//      let addressValidatorViewController = W3WAddressValidatorTableViewController()
//      addressValidatorViewController.colors = self.colors
//      addressValidatorViewController.set(noResultsMessage: "No Results")
//
//      // give it the rows data
//      addressValidatorViewController.set(items: addresses)
//
//      // tell address what to do when a user selects a suggestion
//      addressValidatorViewController.onRowSelected = { address, indexPath in
//        self.userSelected(address: address)
//      }
//
//      //self.show(addressValidatorViewController, sender: self)
//      self.pushViewController(addressValidatorViewController, animated: true)
//    }
//  }
  
  
  /// given an address leaf node, show a summary
  func showSummaryView(suggestion: W3WSuggestion, address: W3WValidatorNodeLeaf) {
    let vc = W3WAddressValidatorSummayViewController(suggestion: suggestion, address: address)
    
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
  

  /// does what it says on the tin
  func updateColors() {
    rootViewController.view.layer.backgroundColor = colors.background.current.cgColor
    view.backgroundColor = colors.background.current.uiColor
    view.layer.backgroundColor = colors.background.current.cgColor
    view.layer.borderColor = colors.background.current.cgColor
  }
  
  
  // MARK: Errors
  
  
  func dealWith(error: W3WAddressValidatorError?) {
    if let e = error {
      dealWith(error: W3WAddressValidatorComponentError.addressValidator(error: e))
    }
  }

  
  func dealWith(error: W3WAddressValidatorComponentError?) {
    if let e = error {
      onError(e)
    }
  }
  
  
  // constants
  let micSize = CGFloat(256.0)
  let logoWidth = CGFloat(64.0)

  
  // functions for the view placements
  func titleFrame()       -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: microphoneFrame().minY - 32.0 - W3WPadding.heavy.value, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 32.0) }
  func microphoneFrame()   -> CGRect { return CGRect(x: (view.frame.width - micSize) / 2.0, y: view.center.y - micSize / 2.0, width: micSize, height: micSize) }
  func descriptionFrame()   -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: microphoneFrame().maxY + W3WPadding.heavy.value, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 32.0) }
  func logoFrame()           -> CGRect { return CGRect(x: view.center.x - logoWidth / 2.0, y: view.frame.height - logoWidth / 2.0 - self.view.safeAreaInsets.bottom, width: logoWidth, height: 11.0) }
  func errorFrame()           -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: microphoneFrame().minY - 56.0 - W3WPadding.heavy.value, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 32.0) }
  func errorDescriptionFrame() -> CGRect { return CGRect(x: W3WPadding.heavy.value, y: microphoneFrame().minY - 52.0, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 64.0) }

  
}





