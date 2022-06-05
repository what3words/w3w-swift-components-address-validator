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


class W3WAddressValidatorSummayView: W3WViewController {
  
  var onConfirm: (W3WValidatorNodeLeaf) -> () = { _ in }
  
  let addressTable = W3WAddressValidatorTableViewController()
  var suggestionNode: W3WValidatorNodeSuggestion!
  
  let suggestion: W3WSuggestion
  let address: W3WValidatorNodeLeaf

  init(suggestion: W3WSuggestion, address: W3WValidatorNodeLeaf, colors: W3WColorSet = .lightDarkMode) {
    self.suggestion = suggestion
    self.address = address

    super.init(nibName: nil, bundle: nil)

    self.colors = colors
    addressTable.colors = colors
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let suggestionNode = W3WValidatorNodeSuggestion(suggestion: suggestion)
    
    addressTable.set(items: [suggestionNode, address])
    addressTable.view.layer.borderColor = W3WColor.iosTertiaryLabel.current.cgColor
    addressTable.view.layer.borderWidth = 0.5
    view.addSubview(addressTable.view)
    
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
    addressTable.tableView.frame = getAddressFrame()
  }

  
  // calculate where the text field goes
  func getAddressFrame() -> CGRect {
    var insets = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
      insets = view.safeAreaInsets
    }

    return CGRect(x: W3WPadding.heavy.value + insets.left, y: W3WPadding.heavy.value + insets.top, width: view.frame.width - W3WPadding.heavy.value * 2.0, height: addressTable.getIdealHeight())
  }
  
  
}
