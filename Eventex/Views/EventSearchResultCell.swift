//
//  EventSearchResultCell.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/28/21.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class EventSearchResultCell: UITableViewCell {
  // MARK: - Instance Variables
  private var downloadTask: URLSessionDownloadTask?
  private var liked = false
  private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
  
  private var eventModel: Event?
  private var likedEventModel: LikedEvent?
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
      performFetchByID(id: eventModel.id)
      for event in likedEvents {
        managedObjectContext.delete(event)
        do {
          try managedObjectContext.save()
          sender.setImage(UIImage(systemName: "heart"), for: .normal)
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
        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      } catch {
        fatalCoreDataError(error)
      }
      
      performFetchByID(id: eventModel.id)
      print(likedEvents)
      print(likedPerformers)
      print(likedVenues)
    }
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
    let likeButton = contentView.viewWithTag(101) as! UIButton
    likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
  }
  


  // MARK: - Helper Methods
  public func configure(for result: Event) {
    self.eventModel = result
    
    let likeButton = contentView.viewWithTag(101) as! UIButton
    
    if eventExists(id: result.id) {
      likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    
    eventTitleLabel.text = result.eventTitle
    eventLocationLabel.text = result.venue.eventLocation
    eventDateLabel.text = formatDate(date: result.dateTime)
    
    if let imageURL = URL(string: result.performers[0].imageURL) {
      downloadTask = eventImage.loadImage(url: imageURL)
    }
  }
  
  public func configureLikedEvents(for likedEvents: LikedEvent, likedPerformers: LikedPerformer, likedVenues: LikedVenue ) {
    self.likedEventModel = likedEvents

    let likeButton = contentView.viewWithTag(101) as! UIButton
    likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    
    
    eventTitleLabel.text = likedEvents.eventTitle
    eventLocationLabel.text = likedVenues.eventLocation
    eventDateLabel.text = formatDate(date: likedEvents.dateTime)
    
    if let imageURL = URL(string: likedPerformers.imageURL) {
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



