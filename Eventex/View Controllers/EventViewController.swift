//
//  ViewController.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/25/21.
//

import UIKit

class EventViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  
  // MARK: - Data Model
  var searchResults = [EventSearchResult]()
  
  // MARK: - Variables
  var hasSearched = false
  
  // MAARK: - Table View Struct
  struct TableView {
    struct CellIdentifiers {
      static let eventSearchResultCell = "EventSearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.becomeFirstResponder()
    
    
    // Register Nibs
    var cellNib = UINib(nibName: TableView.CellIdentifiers.eventSearchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.eventSearchResultCell)
    cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    
  }


}

// MARK: - Search Bar Delegate
extension EventViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchResults = []
    
    if searchBar.text! != "football" {
      for i in 0...10 {
        let searchResult = EventSearchResult()
        searchResult.eventTitle = String(format: "Fake Result %d for", i)
        searchResult.eventLocation = searchBar.text!
        searchResults.append(searchResult)
      }
    }
    
    hasSearched = true
    tableView.reloadData()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: - Table View Delegate
extension EventViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.eventSearchResultCell, for: indexPath) as! EventSearchResultCell
      
      let searchResult = searchResults[indexPath.row]
      cell.eventTitleLabel.text = searchResult.eventTitle
      cell.eventLocationLabel.text = searchResult.eventLocation
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
  
  
}
