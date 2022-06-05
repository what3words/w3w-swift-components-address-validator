//
//  File.swift
//  
//
//  Created by Dave Duprey on 12/05/2022.
//

import Foundation
import UIKit
import W3WSwiftDesign
import W3WSwiftInterfaceCommon


public class W3WAddressValidatorRow: UITableViewCell {
  
  
  // MARK: Vars
  
  /// title for the cell
  var title: String?
  
  /// description for the cell
  var subTitle: String?
  
  /// number of items in the next level down
  var subItemCount: Int?
  
  /// whether or not to show the disclosure indicator and subItemCount
  var disclosureIndicator = false
  
  /// size of the icon
  let iconSize = 24.0
  
  /// size of the count indicator
  let countSize = 32.0
  
  /// count indicator label
  var countLabel: UILabel!
  
  /// colors to use
  var colors = W3WColorSet.lightDarkMode
  
  
  // MARK: Init
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    instantiateUIElements()
  }
  
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    instantiateUIElements()
  }
  
  
  /// set up the UI stuff
  func instantiateUIElements() {
    countLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: countSize, height: countSize)))
    countLabel.font = UIFont.systemFont(ofSize: 12.0)
    countLabel.textAlignment = .center
    countLabel.minimumScaleFactor = 0.5
    countLabel.adjustsFontSizeToFitWidth = true
    countLabel.layer.cornerRadius = countSize / 2.0
    addSubview(countLabel)
    
    updateColours()
  }

  
  public override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  
  // MARK: Accessors
  
  public func set(title: String?, subTitle: String?, subItemCount: Int? = nil, disclosureIndicator: Bool = false) {
    self.title = title
    self.subTitle = subTitle
    self.subItemCount = subItemCount
    self.disclosureIndicator = disclosureIndicator
    
    self.textLabel?.text = title
    self.detailTextLabel?.text = subTitle
    self.imageView?.image = disclosureIndicator ? W3WIcons.pinMulti : W3WIcons.pin
    //UIImage(named: disclosureIndicator ? "addressValidationPinMultiBlack" : "addressValidationPinBlack")
    
    if disclosureIndicator {
      accessoryType = .disclosureIndicator
    }
    
    if let count = subItemCount {
      if count > 0 {
        countLabel.isHidden = false
        countLabel.text = String(count)
        return
      }
    }

    countLabel.isHidden = true
  }
  
  
  // MARK: Color modes
  
  
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    updateColours()
  }
  

  func updateColours() {
    self.textLabel?.textColor = colors.foreground.current.uiColor
    self.detailTextLabel?.textColor = colors.secondary.current.uiColor
    self.backgroundColor = colors.background.current.uiColor
    countLabel.textColor = colors.background.current.uiColor
    countLabel.layer.backgroundColor = colors.highlight.current.cgColor
  }
  
  
  // MARK: Layout
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    updateColours()
    
    self.imageView?.frame = CGRect(x: W3WPadding.medium.value, y: (frame.height - iconSize) / 2.0, width: iconSize, height: iconSize)
    
    if let f = self.textLabel?.frame, let imageFrame = imageView?.frame {
      let newX = imageFrame.origin.x + iconSize + W3WPadding.medium.value
      //self.textLabel?.frame = CGRect(x: newX, y: f.origin.y, width: f.width, height: f.height)
      self.textLabel?.frame = CGRect(x: newX, y: f.origin.y, width: frame.width - newX, height: f.height)
    }
    
    if let f = self.detailTextLabel?.frame, let imageFrame = imageView?.frame {
      let newX = imageFrame.origin.x + iconSize + W3WPadding.medium.value
      //self.detailTextLabel?.frame = CGRect(x: newX, y: f.origin.y, width: f.width, height: f.height)
      self.detailTextLabel?.frame = CGRect(x: newX, y: f.origin.y, width: frame.width - newX, height: f.height)
    }
    
    countLabel.frame = CGRect(
      x: frame.size.width - W3WPadding.medium.value - countSize - (disclosureIndicator ? countSize : 0.0),
      y: (frame.height - countSize) / 2.0,
      width: countSize,
      height: countSize)
  }
  
  
}
