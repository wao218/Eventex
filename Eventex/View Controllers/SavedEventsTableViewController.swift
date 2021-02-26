//
//  SavedEventsTableViewController.swift
//  Eventex
//
//  Created by Wesley Osborne on 2/26/21.
//

import UIKit
import CoreData

class SavedEventsTableViewController: UITableViewController {
  
  private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
  
  private var likedEvents = [LikedEvent]()
  private var likedVenues = [LikedVenue]()
  private var likedPerformers = [LikedPerformer]()
  
  var rowSelected: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let cellNib = UINib(nibName: "EventSearchResultCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "EventSearchResultCell")
    
    performFetch()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    performFetch()
    tableView.reloadData()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    return likedEvents.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EventSearchResultCell", for: indexPath) as! EventSearchResultCell

    // Configure the cell...
    let events = likedEvents[indexPath.row]
    let performers = likedPerformers[indexPath.row]
    let venues = likedVenues[indexPath.row]
    cell.configureLikedEvents(for: events, likedPerformers: performers, likedVenues: venues)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  
  
  // MARK: - Helper Methods
  private func performFetch() {
    let eventFetchRequest = NSFetchRequest<LikedEvent>()
    let eventEntity = LikedEvent.entity()
    eventFetchRequest.entity = eventEntity
  
    let performerFetchRequest = NSFetchRequest<LikedPerformer>()
    let performerEntity = LikedPerformer.entity()
    performerFetchRequest.entity = performerEntity
    
    let venueFetchRequest = NSFetchRequest<LikedVenue>()
    let venueEntity = LikedVenue.entity()
    venueFetchRequest.entity = venueEntity
  
    do {
      likedEvents = try managedObjectContext.fetch(eventFetchRequest)
      likedPerformers = try managedObjectContext.fetch(performerFetchRequest)
      likedVenues = try managedObjectContext.fetch(venueFetchRequest)
    } catch {
      fatalCoreDataError(error)
    }
  }


}
