//
//  File.swift
//  
//
//  Created by Dave Duprey on 23/05/2022.
//

#if canImport(W3WSwiftAddressValidators)

import UIKit
import W3WSwiftDesign
import W3WSwiftInterfaceElements
import W3WSwiftAddressValidators


public class W3WAddressValidatorTableViewController: W3WTableViewController<W3WValidatorNode, W3WAddressValidatorRow> {
  
  
  // MARK: Vars
  
  
  /// colors to use
  var colors = W3WColorSet.lightDarkMode

  
  // MARK: Init
  
  
  public override init() {
    super.init()
    registerSuggestionCell()
  }
  
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    registerSuggestionCell()
  }
  

  // MARK: cellForRowAt
  
  /// make a table view cell for a new row
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    
    if let node = getItem(at: indexPath) {
      if let n = node as? W3WValidatorNodeSuggestion {
        cell = getSuggestionCell(node: n, indexPath: indexPath)
        if let sc = cell as? W3WSuggestionsTableViewCell {
          sc.colors = colors
          sc.updateColors()
        }
        
      } else {
        cell = getAddressCell(node: node, indexPath: indexPath)
        if let avc = cell as? W3WAddressValidatorRow {
          avc.colors = colors
        }
      }
    }
    
    return cell ?? UITableViewCell()
  }
  
  
  // MARK: Address cells
  
  
  func getAddressCell(node: W3WValidatorNode, indexPath: IndexPath) -> UITableViewCell {
    let cell = getReusableCell(indexPath: indexPath)
    
    if let n = node as? W3WValidatorNodeList {
      cell.set(title: n.name, subTitle: n.nearestPlace, subItemCount: n.subItemCount, disclosureIndicator: true)
    } else if let n = node as? W3WValidatorNodeLeaf {
      cell.set(title: n.name, subTitle: n.nearestPlace, subItemCount: nil, disclosureIndicator: false)
    } else if let n = node as? W3WValidatorNodeLeafInfo {
      cell.set(title: n.name, subTitle: n.nearestPlace, subItemCount: nil, disclosureIndicator: false)
    } else {
      cell.set(title: node.name, subTitle: node.nearestPlace, subItemCount: nil, disclosureIndicator: false)
    }
    
    return cell
  }

  
  // MARK: Suggestion Cells
  
  
  // this is for the top list where the results are what3words
  let suggestionCellIdentifier = String(describing: W3WSuggestionsTableViewCell.self)
  
  
  func registerSuggestionCell() {
    self.tableView.register(W3WSuggestionsTableViewCell.self, forCellReuseIdentifier: suggestionCellIdentifier)
  }
  
  
  func getSuggestionCell(node: W3WValidatorNodeSuggestion, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCellIdentifier, for: indexPath) as! W3WSuggestionsTableViewCell
    cell.set(suggestion: node.suggestion)
    return cell
  }
  
  
}


#endif
