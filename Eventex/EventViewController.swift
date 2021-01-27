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
  var searchResults = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }


}

// MARK: - Search Bar Delegate
extension EventViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchResults = []
    for i in 0...10 {
      searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text!))
    }
    tableView.reloadData()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: - Table View Delegate
extension EventViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "SearchResultCell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    cell.textLabel!.text = searchResults[indexPath.row]
    
    return cell
  }
  
  
}
