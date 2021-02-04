//
//  EventSearchResultCell.swift
//  Eventex
//
//  Created by Wesley Osborne on 1/28/21.
//

import UIKit

class EventSearchResultCell: UITableViewCell {
  
  // MARK: - IBOutlets
  @IBOutlet var eventTitleLabel: UILabel!
  @IBOutlet var eventLocationLabel: UILabel!
  @IBOutlet var eventDateLabel: UILabel!
  @IBOutlet var eventImage: UIImageView!
  
  // MARK: - IBActions
  @IBAction func likeButton(_ sender: UIButton) {
    print("like button pressed")
    if !likedEvent {
      likedEvent = true
      sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      print("Value of likedEvent when I like something: \(likedEvent)")
    } else {
      likedEvent = false
      sender.setImage(UIImage(systemName: "heart"), for: .normal)
      print("Value of likedEvent when I unlike something: \(likedEvent)")
    }
  }
  
  // MARK: - Instance Variables
  var downloadTask: URLSessionDownloadTask?
  var likedEvent = false

  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(named: "SelectionColor")?.withAlphaComponent(0.5)
    selectedBackgroundView = selectedView
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
  func configure(for result: Event) {
    eventTitleLabel.text = result.eventTitle
    eventLocationLabel.text = result.venue.eventLocation
    eventDateLabel.text = result.dateTime
    
//    print(result.performers[0].imageURL)
    
    if let imageURL = URL(string: result.performers[0].imageURL) {
      downloadTask = eventImage.loadImage(url: imageURL)
    }
  }
  
}
