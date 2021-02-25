//
//  EventSearchResultCell.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/28/21.
//

import UIKit
import CoreData

class EventSearchResultCell: UITableViewCell {
  // MARK: - Instance Variables
  private var downloadTask: URLSessionDownloadTask?
  private var liked = false
  private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
  
  private var eventModel: Event?
  private var likedEvents = [LikedEvent]()
  private var likedVenues = [LikedVenue]()
  private var likedPerformers = [LikedPerformer]()
  
  
  

  
  // MARK: - IBOutlets
  @IBOutlet var eventTitleLabel: UILabel!
  @IBOutlet var eventLocationLabel: UILabel!
  @IBOutlet var eventDateLabel: UILabel!
  @IBOutlet var eventImage: UIImageView!

  
  @IBAction func didTapLikeButton(_ sender: AnyObject) {
    guard let eventModel = eventModel else {
      return
    }
    
    if eventExists(id: eventModel.id) {
      print("This event exists delete it")
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
        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      } catch {
        fatalCoreDataError(error)
      }
    }
    
//    for event in likedEvents {
//      if event.id == eventModel.id {
//        managedObjectContext.delete(event)
//        do {
//          try managedObjectContext.save()
//          sender.setImage(UIImage(systemName: "heart"), for: .normal)
//        } catch {
//          fatalCoreDataError(error)
//        }
//      }
//    }
        
  }
  

  
  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(named: "SelectionColor")?.withAlphaComponent(0.5)
    selectedBackgroundView = selectedView
//    performFetch()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }
  


  // MARK: - Helper Methods
  public func configure(for result: Event) {
    self.eventModel = result
    // TODO: Check if event is already in liked events
    // TODO: If it is in Core Data return core data else return api event
    let likeButton = contentView.viewWithTag(101) as! UIButton
    
    
    eventTitleLabel.text = result.eventTitle
    eventLocationLabel.text = result.venue.eventLocation
    eventDateLabel.text = formatDate(date: result.dateTime)
    
    if let imageURL = URL(string: result.performers[0].imageURL) {
      downloadTask = eventImage.loadImage(url: imageURL)
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



