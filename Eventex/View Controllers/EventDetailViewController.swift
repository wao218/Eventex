//
//  EventDetailViewController.swift
//  Eventex
//
//  Created by Wesley Osborne on 2/25/21.
//

import UIKit
import CoreData

class EventDetailViewController: UIViewController {
  
    
  
  private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
  public var eventModel: Event?
  public var likedEventModel: LikedEvent?
  public var tableView: UITableView?
  private var downloadTask: URLSessionDownloadTask?

  private var likedEvents = [LikedEvent]()
  private var likedVenues = [LikedVenue]()
  private var likedPerformers = [LikedPerformer]()
  
  @IBOutlet var eventTitleLabel: UILabel!
  @IBOutlet var eventLocationLabel: UILabel!
  @IBOutlet var eventDateLabel: UILabel!
  @IBOutlet var eventImage: UIImageView!
  @IBOutlet weak var likeButton: UIBarButtonItem!
  
  @IBAction func didTabMoreDetailsButton() {
    guard let event = eventModel else {
      return
    }
    if let url = URL(string: event.url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  @IBAction func didTapBackbutton() {
    self.dismiss(animated: true, completion: nil)
    DispatchQueue.main.async {
      self.tableView?.reloadData()
    }
  }
  
  @IBAction func didTapLikeButton(_ sender: AnyObject) {
    guard let eventModel = eventModel else {
      return
    }
    
    if eventExists(id: eventModel.id) {
      print("This event exists delete it")
      performFetchByID(id: eventModel.id)
      for event in likedEvents {
        managedObjectContext.delete(event)
        do {
          try managedObjectContext.save()
          likeButton.image = UIImage(systemName: "heart")
        } catch {
          fatalCoreDataError(error)
        }
      }
      
    } else {
      let likedEvent = LikedEvent(context: managedObjectContext)
      let likedPerformer = LikedPerformer(context: managedObjectContext)
      let likedVenue = LikedVenue(context: managedObjectContext)
      likedEvent.id = Int64(eventModel.id)
      likedEvent.eventTitle = eventModel.eventTitle
      likedEvent.dateTime = eventModel.dateTime
      likedPerformer.imageURL = eventModel.performers[0].imageURL
      likedVenue.eventLocation = eventModel.venue.eventLocation
      likedVenue.event = likedEvent
      likedPerformer.event = likedEvent
      
      do {
        try managedObjectContext.save()
        likeButton.image = UIImage(systemName: "heart.fill")
      } catch {
        fatalCoreDataError(error)
      }
      
      performFetchByID(id: eventModel.id)
      print(likedEvents)
      print(likedPerformers)
      print(likedVenues)
    }
  }


  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let event = eventModel else {
      return
    }
    eventTitleLabel.text = event.eventTitle
    eventLocationLabel.text = event.venue.eventLocation
    eventDateLabel.text = formatDate(date: event.dateTime)
    
    if let imageURL = URL(string: event.performers[0].imageURL) {
      downloadTask = eventImage.loadImage(url: imageURL)
    }
    
    if eventExists(id: event.id) {
      likeButton.image = UIImage(systemName: "heart.fill")
    }
  
  }
  
  private func formatDate(date: String) -> String {
    let dateformatterGet = DateFormatter()
    dateformatterGet.locale = Locale(identifier: "en_US_POSIX")
    dateformatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM dd,yyy h:mm a"
    if let date = dateformatterGet.date(from: date) {
      return dateFormatterPrint.string(from: date)
    } else {
      return "Unkown"
    }
  }
  
  private func performFetchByID(id: Int) {
    let eventFetchRequest = NSFetchRequest<LikedEvent>()
    let eventEntity = LikedEvent.entity()
    eventFetchRequest.entity = eventEntity
    eventFetchRequest.predicate = NSPredicate(format: "id = %d", id)
    
    
    
    let performerFetchRequest = NSFetchRequest<LikedPerformer>()
    let performerEntity = LikedPerformer.entity()
    performerFetchRequest.entity = performerEntity
    performerFetchRequest.predicate = NSPredicate(format: "event.id = %d", id)
    
    
    let venueFetchRequest = NSFetchRequest<LikedVenue>()
    let venueEntity = LikedVenue.entity()
    venueFetchRequest.entity = venueEntity
    venueFetchRequest.predicate = NSPredicate(format: "event.id = %d", id)
    
    do {
      likedEvents = try managedObjectContext.fetch(eventFetchRequest)
      likedPerformers = try managedObjectContext.fetch(performerFetchRequest)
      likedVenues = try managedObjectContext.fetch(venueFetchRequest)
    } catch {
      fatalCoreDataError(error)
    }
  }
  
  private func eventExists(id: Int) -> Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedEvent")
    fetchRequest.predicate = NSPredicate(format: "id = %d", id)
    fetchRequest.includesSubentities = false
    
    var entitiesCount = 0
    
    do {
      entitiesCount = try managedObjectContext.count(for: fetchRequest)
    } catch {
      fatalCoreDataError(error)
    }
    
    return entitiesCount > 0
  }

}
