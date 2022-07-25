//
//  W3WAutosuggestSearchController2.swift
//  
//
//  Created by Dave Duprey on 27/06/2022.
//

import UIKit
import W3WSwiftApi
import W3WSwiftComponents
import W3WSwiftInterfaceElements
import W3WSwiftAddressValidators


public class W3WAutoSearchController: W3WSearchController, W3WAutoSuggestTextFieldProtocol {

  /// callback for when the user choses a suggestion
  lazy public var onSuggestionSelected: W3WSuggestionResponse = { _ in }
  
  /// To be DEPRECIATED: use onSuggestionSelected instead - old callback for when the user choses a suggestion, to be depreciate
  @available(*, deprecated, renamed: "onSuggestionSelected")
  public var suggestionSelected: W3WSuggestionResponse = { _ in }
  
  /// if freeFormText is enabled, this will be called everytime the text field is edited
  public var textChanged: W3WTextChangedResponse = { _ in }
  
  /// returns the error enum for any error that occurs
  public var onError: W3WAutoSuggestTextFieldErrorResponse = { _ in }

  /// this is the view controller for displaying the suggestions
  var suggestionsTableViewController = W3WAddressValidatorTableViewController()
  
  /// this communicates with the w3w server
  var autosuggest: W3WAutosuggestHelper!
  
  /// autosuggest options
  var options = [W3WOption]()


  public init(w3w: W3WProtocolV3) {
    super.init(searchResultsController: suggestionsTableViewController)
    configure(w3w: w3w)
  }
  
  
  public required init?(coder: NSCoder) {
    super.init(searchResultsController: suggestionsTableViewController)
  }
  
  
  func configure(w3w: W3WProtocolV3) {
    autosuggest = W3WAutosuggestHelper(w3w)
    
    onTextChange = { [weak self] text in
      if w3w.isPossible3wa(text: text) {
        self?.autosuggest.update(text: text, options: self?.options ?? []) { error in
          self?.on(suggestions: self?.autosuggest.suggestions ?? [], error: error)
        }
      } else {
        self?.set(suggestions: [])
      }
     
      return true
    }
    
    suggestionsTableViewController.onRowSelected = { [weak self] item, indexPath in
      if let suggestion = self?.suggestionsTableViewController.getItem(at: indexPath) as? W3WValidatorNodeSuggestion {
        self?.onSuggestionSelected(suggestion.suggestion)
      }
    }
  }

  
  override public func viewDidLoad() {
    super.viewDidLoad()
  }
  

  func on(suggestions: [W3WSuggestion], error: W3WError?) {
    set(suggestions: suggestions)
  }
  
  
  /// put suggestions into the component
  /// - Parameters:
  ///     - suggestions: the new suggestions
  public func set(suggestions: [W3WSuggestion]) {
    var nodes = [W3WValidatorNode]()
    
    for suggestion in suggestions {
      nodes.append(W3WValidatorNodeSuggestion(suggestion: suggestion))
    }
    
    suggestionsTableViewController.set(items: nodes)
  }

  
  public func set(options: [W3WOption]) {
    self.options = options
  }
  
  
  public func set(_ w3w: W3WProtocolV3, language: String = "en") {
    configure(w3w: w3w)
    set(language: language)
  }
  
  
  public func set(freeformText: Bool) {
  }
  

  public func set(allowInvalid3wa: Bool) {
  }
  

  public func set(language l: String) {
  }
  

  public func set(voice: Bool) {
  }
  

  public func set(display: W3WSuggestion?) {
  }

  
  /// NOTE: this causes the component to use the converToCoordinates call, which may count against your quota
  public func set(includeCoordinates: Bool) {
  }
  

  
}
