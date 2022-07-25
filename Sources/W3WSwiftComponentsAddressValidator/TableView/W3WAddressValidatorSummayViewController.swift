//
//  File.swift
//  
//
//  Created by Dave Duprey on 24/05/2022.
//

import UIKit
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftInterfaceElements
import W3WSwiftAddressValidators
import SwiftUI


/// shows an address and asks the user to confirm the information
public class W3WAddressValidatorSummayViewController: W3WViewController {
  
  // called when the user presses the [confirm] button
  var onConfirm: (W3WValidatorNodeLeaf) -> () = { _ in }
  
  // a summary of the address info
  lazy var addressSummary = W3WStreetAddressSummaryView(node: self.address)
  
  // the node containing the W3WSuggestion
  var suggestionNode: W3WValidatorNodeSuggestion!
  
  // the suggestion
  let suggestion: W3WSuggestion
  
  // the street address
  let address: W3WValidatorNodeLeaf

  
  /// instantiate a W3WAddressValidatorSummayViewController
  /// - Parameters:
  ///     - suggestion: the suggestion to show
  ///     - address: the node containing the street address
  ///     - colors: the colour set to use (optional)
  public init(suggestion: W3WSuggestion, address: W3WValidatorNodeLeaf, colors: W3WColorSet = .lightDarkMode) {
    self.suggestion = suggestion
    self.address = address

    super.init(nibName: nil, bundle: nil)

    self.colors = colors
  }
  

  /// not supported yet
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()

    // add the summry sub view
    view.addSubview(addressSummary)
    
    // make and add a confirm button
    let confirmButton = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(buttonPressed))
    confirmButton.title = "Confirm"
    self.navigationItem.rightBarButtonItem = confirmButton
  }

  
  // MARK: Events
  
  
  @objc
  func buttonPressed() {
    onConfirm(address)
  }
  
  
  // MARK: UIViewController stuff
  
  
  // update subview positions
  public override func viewWillLayoutSubviews() {
    addressSummary.frame = getAddressFrame()
  }

  
  // calculate where the text field goes
  func getAddressFrame() -> CGRect {
    var insets = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
      insets = view.safeAreaInsets
    }

    return CGRect(x: W3WPadding.heavy.value + insets.left, y: W3WPadding.heavy.value + insets.top, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: 113.0)
  }
  
  
}
