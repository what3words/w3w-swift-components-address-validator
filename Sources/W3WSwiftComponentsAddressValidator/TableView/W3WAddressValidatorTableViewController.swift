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
  
  
  /// sets up the UI
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    //tableView.separatorInset = UIEdgeInsets(top: 0.0, left: W3WPadding.bold.value, bottom: 0.0, right: W3WPadding.bold.value)
    tableView.separatorStyle = .none
  }

  
  // MARK: tableView
  
  
  override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var v:UILabel? = nil
    
    if let node = getItem(at: IndexPath(row: 0, section: 0)) {
      if !(node is W3WValidatorNodeSuggestion) {
        v = W3WWordsView(words: node.words ?? "", font: .systemFont(ofSize: 17.0, weight: .bold))
      }
    }

    return v
  }
  
  
  override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    var height:CGFloat = 0.0
    
    if let node = getItem(at: IndexPath(row: 0, section: 0)) {
      if !(node is W3WValidatorNodeSuggestion) {
        height = 44.0
      }
    }
    
    return height
  }
  
  
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
  
  
  /// depending on the type of node passed in, present a different kind of cell
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
  
  
  // register a second tpye of cell for suggestions
  func registerSuggestionCell() {
    self.tableView.register(W3WSuggestionsTableViewCell.self, forCellReuseIdentifier: suggestionCellIdentifier)
  }
  
  
  // make a suggestion cell
  func getSuggestionCell(node: W3WValidatorNodeSuggestion, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCellIdentifier, for: indexPath) as! W3WSuggestionsTableViewCell
    cell.set(suggestion: node.suggestion)
    return cell
  }
  
  
  // MARK: UITableViewController overrides
  
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: parent?.view.frame.height ?? 128.0)
  }

  
}


#endif
