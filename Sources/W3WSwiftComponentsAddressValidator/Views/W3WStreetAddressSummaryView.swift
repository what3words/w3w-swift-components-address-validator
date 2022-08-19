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
import W3WSwiftInterfaceElements


/// A UIView that shows a three word address AND a stret address
public class W3WStreetAddressSummaryView: UIView {
  
  // the three word address sub view
  let w3wLabel = UILabel()
  
  // the street address sub view
  let addressLabel = UILabel()

  // separator line
  let line = UIView(frame: .w3wWhatever)

  
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
  func configure(words: W3WString, address: W3WString) {
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
    w3wLabel.attributedText = words.asAttributedString()
    addSubview(w3wLabel)
    
    // the address label
    addressLabel.numberOfLines = 0
    addressLabel.font = UIFont.systemFont(ofSize: 14.0)
    addressLabel.textColor = W3WColor.secondaryDarkGray.current.uiColor
    addressLabel.attributedText = address.asAttributedString()
    addressLabel.minimumScaleFactor = 0.5
    addressLabel.adjustsFontSizeToFitWidth = true
    addSubview(addressLabel)
    
    
    line.backgroundColor = W3WColor.systemGray6.current.uiColor
    addSubview(line)
  }
  
  
  /// makes a 3wa attributed string.  TODO rewrite with the new W3WString stuff
  func make3waText(words: String?, size: CGFloat = 17.0) -> W3WString {
    //return NSAttributedString(threeWordAddress: words ?? "none", font: UIFont.systemFont(ofSize: size, weight: .semibold))
    
    let strippedWords = words?.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    let slashes = W3WString("///", color: .red)
    let twa     = W3WString(strippedWords ?? "---.---.---", color: .darkBlue)
    
    return (slashes + twa)
  }
  
  
  /// makes a 3wa attributed string.  TODO rewrite with the new W3WString stuff
  func makeAddressText(address: W3WSwiftAddressValidators.W3WStreetAddressProtocol?) -> W3WString { //} NSAttributedString {
    var string = W3WString()
    let font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    
    if let uk = address as? W3WSwiftAddressValidators.W3WStreetAddressUK {
      if let addstr = uk.address {
        if addstr.count == 0 {
          string += W3WString((uk.street ?? "") + "\n", color: .black, font: font)
          string += W3WString(address?.makeField(from: [uk.locality, uk.postCode], separator: ", ") ?? "", font: font)
        } else {
          string += W3WString(addstr + "\n", color: .black, font: font)
          string += W3WString(address?.makeField(from: [uk.street, uk.locality, uk.postCode], separator: ", ") ?? "", font: font)
        }
      } else {
        string += W3WString((uk.street ?? "") + "\n", color: .black, font: font)
        string += W3WString(address?.makeField(from: [uk.locality, uk.postCode], separator: ", ") ?? "", font: font)
      }
    }  else if let addr = address as? W3WSwiftAddressValidators.W3WStreetAddressGeneric {
      if let addstr = addr.address {
        if addstr.count == 0 {
          string += W3WString((addr.street ?? "") + "\n", color: .black, font: font)
          string += W3WString(address?.makeField(from: [addr.city, addr.postCode], separator: ", ") ?? "", font: font)
        } else {
          string += W3WString(addstr + "\n", color: .black, font: font)
          string += W3WString(address?.makeField(from: [addr.street, addr.city, addr.postCode], separator: ", ") ?? "", font: font)
        }
      } else {
        string += W3WString((addr.street ?? "") + "\n", color: .black, font: font)
        string += W3WString(address?.makeField(from: [addr.city, addr.postCode], separator: ", ") ?? "", font: font)
      }
      
    } else {
      string += W3WString(address?.description.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: ", ") ?? "None")
    }
   
    return string
    
//    let text = NSMutableAttributedString()
//
//    if let uk = address as? W3WSwiftAddressValidators.W3WStreetAddressUK {
//      if let addstr = uk.address {
//        if addstr.count == 0 {
//          text.append(NSAttributedString(string: (uk.street ?? "") + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
//          text.append(NSAttributedString(string: address?.makeField(from: [uk.locality, uk.postCode], separator: ", ") ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]))
//        } else {
//          text.append(NSAttributedString(string: addstr + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
//          text.append(NSAttributedString(string: address?.makeField(from: [uk.street, uk.locality, uk.postCode], separator: ", ") ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]))
//        }
//      } else {
//        text.append(NSAttributedString(string: (uk.street ?? "") + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
//        text.append(NSAttributedString(string: address?.makeField(from: [uk.locality, uk.postCode], separator: ", ") ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]))
//      }
//
//    } else if let addr = address as? W3WSwiftAddressValidators.W3WStreetAddressGeneric {
//      if let addstr = addr.address {
//        text.append(NSAttributedString(string: addstr + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
//        text.append(NSAttributedString(string: address?.makeField(from: [addr.street, addr.city, addr.postCode], separator: ", ") ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]))
//      } else {
//        text.append(NSAttributedString(string: (addr.street ?? "") + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
//        text.append(NSAttributedString(string: address?.makeField(from: [addr.city, addr.postCode], separator: ", ") ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)]))
//      }
//
//    } else {
//      text.append(NSAttributedString(string: address?.description.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: ", ") ?? "None"))
//    }
//
//    return text
  }
  
  
  /// makes a attributed string for a street address.  TODO rewrite with the new W3WString stuff
  func makeAddressText(node: W3WValidatorNodeLeaf?) -> W3WString { // NSAttributedString {
    var string = W3WString()
    let font14 = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    let font16 = UIFont.systemFont(ofSize: 16.0, weight: .bold)

    let title = node?.name ?? "?"
    string += W3WString(title + "\n", color: .black, font: font16)
    
    let description = node?.nearestPlace?.replacingOccurrences(of: "\n", with: ", ") ?? "?"
    string += W3WString(description, font: font14)

    return string

//    let text = NSMutableAttributedString()
//
//    let title = node?.name ?? "?"
//    text.append(NSAttributedString(string: title + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold), .foregroundColor: W3WColor.black.current.uiColor]))
//
//    let description = node?.nearestPlace?.replacingOccurrences(of: "\n", with: ", ") ?? "?"
//    text.append(NSAttributedString(string: description, attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)]))
//
//    return text
  }
  

  /// manage the sub views
  public override func layoutSubviews() {
    let padding = W3WPadding.light.value
    w3wLabel.frame = CGRect(x: padding * 1.5, y: 0.0, width: frame.width - padding * 3.0, height: frame.height * (1.0 - 0.618))
    addressLabel.frame = CGRect(x: padding * 1.5, y: w3wLabel.frame.maxY, width: frame.width - padding * 3.0, height: frame.height * 0.618)
    //line.frame = CGRect(x: 0.0, y: (w3wLabel.frame.maxY + addressLabel.frame.minY) / 2.0, width: frame.width, height: 1.0)
    line.frame = CGRect(x: 0.0, y: w3wLabel.frame.maxY, width: frame.width, height: 1.0)
  }
  
}
