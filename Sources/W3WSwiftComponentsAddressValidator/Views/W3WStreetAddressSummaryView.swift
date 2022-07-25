//
//  ResultsTable.swift
//  AddressValidation
//
//  Created by Dave Duprey on 08/07/2022.
//

import Foundation
import UIKit
import W3WSwiftDesign
import W3WSwiftAddressValidators


/// A UIView that shows a three word address AND a stret address
public class W3WStreetAddressSummaryView: UIView {
  
  // the three word address sub view
  let w3wLabel = UILabel()
  
  // the street address sub view
  let addressLabel = UILabel()

  
  /// init from a street address
  public init(address: W3WStreetAddressProtocol?) {
    super.init(frame: .w3wWhatever)
    configure(words: make3waText(words: address?.words), address: makeAddressText(address: address))
  }
  
  
  /// init form a address validator node
  public init(node: W3WValidatorNodeLeaf?) {
    super.init(frame: .w3wWhatever)
    configure(words: make3waText(words: node?.words), address: makeAddressText(node: node))
  }
  
  
  required init(coder: NSCoder) {
    super.init(frame: .w3wWhatever)
  }
  

  /// set up the UI and content
  func configure(words: NSAttributedString, address: NSAttributedString) {
    // the layer values
    layer.backgroundColor = W3WColor.white.current.cgColor
    layer.cornerRadius  = W3WCornerRadius.soft.value
    layer.borderColor   = W3WColor.systemGray6.current.cgColor
    layer.borderWidth   = 1.0
    layer.shadowRadius  = 1.0
    layer.shadowColor   = W3WColor.systemGray4.current.cgColor
    layer.shadowOpacity = 1.0
    layer.shadowOffset  = CGSize(width: 0.5, height: 0.5)
    
    // the what3words label
    w3wLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    w3wLabel.attributedText = words
    addSubview(w3wLabel)
    
    // the address label
    addressLabel.numberOfLines = 0
    addressLabel.font = UIFont.systemFont(ofSize: 14.0)
    addressLabel.textColor = W3WColor.secondaryDarkGray.current.uiColor
    addressLabel.attributedText = address
    addressLabel.minimumScaleFactor = 0.5
    addressLabel.adjustsFontSizeToFitWidth = true
    addSubview(addressLabel)
  }
  
  
  /// makes a 3wa attributed string.  TODO rewrite with the new W3WString stuff
  func make3waText(words: String?, size: CGFloat = 17.0) -> NSAttributedString {
    return NSAttributedString(threeWordAddress: words ?? "none", font: UIFont.systemFont(ofSize: size, weight: .semibold))
  }
  
  
  /// makes a 3wa attributed string.  TODO rewrite with the new W3WString stuff
  func makeAddressText(address: W3WStreetAddressProtocol?) -> NSAttributedString {
    let text = NSMutableAttributedString()
    
    if let uk = address as? W3WStreetAddressUK, let addstr = uk.address {
      text.append(NSAttributedString(string: addstr + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
      text.append(NSAttributedString(string: (uk.street ?? "") + ", " + (uk.locality ?? "") + "," + (uk.postCode ?? ""), attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]))
      
    } else if let uk = address as? W3WStreetAddressGeneric, let addstr = uk.address {
      text.append(NSAttributedString(string: addstr + "\n", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
      text.append(NSAttributedString(string: (uk.street ?? "") + ", " + (uk.city ?? "") + "," + (uk.postCode ?? ""), attributes: [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)]))
      
    } else {
      text.append(NSAttributedString(string: address?.description ?? "None"))
    }
    
    return text
  }
  
  
  /// makes a attributed string for a street address.  TODO rewrite with the new W3WString stuff
  func makeAddressText(node: W3WValidatorNodeLeaf?) -> NSAttributedString {
    let text = NSMutableAttributedString()

    let title = node?.name ?? "?"
    text.append(NSAttributedString(string: title + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))

    let description = node?.nearestPlace ?? "?"
    text.append(NSAttributedString(string: description, attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)]))
    
    return text
  }
  

  /// manage the sub views
  public override func layoutSubviews() {
    let padding = W3WPadding.light.value
    w3wLabel.frame = CGRect(x: padding, y: padding, width: frame.width - padding * 2.0, height: frame.height * (1.0 - 0.7))
    addressLabel.frame = CGRect(x: padding, y: w3wLabel.frame.maxY, width: frame.width - padding * 2.0, height: frame.height * 0.65)
  }
  
}
