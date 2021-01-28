//
//  ViewController.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/25/21.
//

import UIKit

class EventViewController: UIViewController {
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  
  // Data Model
  var searchResults = [EventSearchResult]()
  
  var hasSearched = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    let cellIdentifier = "SearchResultCell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    if cell == nil {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
    
    if searchResults.count == 0 {
      cell.textLabel!.text = "(Nothing found)"
      cell.detailTextLabel!.text = ""
    } else {
      let searchResult = searchResults[indexPath.row]
      cell.textLabel!.text = searchResult.eventTitle
      cell.detailTextLabel!.text = searchResult.eventLocation
    }
    
    return cell
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
