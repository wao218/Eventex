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
  var searchResults = [Event]()
  
  // MARK: - State Variables
  var hasSearched = false
  var isLoading = false
  
  // MAARK: - Table View Struct
  struct TableView {
    struct CellIdentifiers {
      static let eventSearchResultCell = "EventSearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
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
    cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    
  }
  
  // MARK: - Helper Methods
  
  // Create valid url
  func seatGeekURL(searchText: String) -> URL {
    
    // access environment variables
    let clientID = ProcessInfo.processInfo.environment["CLIENTID"]
    
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "https://api.seatgeek.com/2/events?client_id=\(clientID!)&q=%@&per_page=200", encodedText)
    let url = URL(string: urlString)
    return url!
  }
  
  // Parse JSON Data
  func parse(data: Data) -> [Event] {
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(Events.self, from: data)
      return result.events
    } catch {
      print("JSON Error: \(error)")
      return []
    }
  }
  
  // Alert to Handle Network Errors
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the SeatGeak Server. Please try again.", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

}

// MARK: - Search Bar Delegate
extension EventViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      
      isLoading = true
      tableView.reloadData()
      
      hasSearched = true
      searchResults = []
      
      // Perform Search Request & Fetch contents of URL
      let url = seatGeekURL(searchText: searchBar.text!)
      let session = URLSession.shared
      let dataTask = session.dataTask(with: url) {data, response, error in
        
        if let error = error {
          print("Failure! \(error.localizedDescription)")
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
          if let data = data {
            self.searchResults = self.parse(data: data)
            DispatchQueue.main.async {
              self.isLoading = false
              self.tableView.reloadData()
            }
            return
          }
        } else {
          print("Failure! \(response!)")
        }
        
        DispatchQueue.main.async {
          self.hasSearched = false
          self.isLoading = false
          self.tableView.reloadData()
          self.showNetworkError()
        }
      }
      dataTask.resume()
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: - Table View Delegate
extension EventViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isLoading {
      return 1
    } else if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
      
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
      
    } else {
      
      if searchResults.count == 0 {
        return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.eventSearchResultCell, for: indexPath) as! EventSearchResultCell
        
        let searchResult = searchResults[indexPath.row]
        
        cell.eventTitleLabel.text = searchResult.eventTitle
        cell.eventLocationLabel.text = searchResult.venue.eventLocation
        cell.eventDateLabel.text = searchResult.dateTime
        return cell
      }
    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 || isLoading {
      return nil
    } else {
      return indexPath
    }
  }
  
  
}
