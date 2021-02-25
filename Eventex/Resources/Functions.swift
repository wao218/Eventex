//
//  Functions.swift
//  Eventex
//
//  Created by Wesley Osborne on 2/23/21.
//

import Foundation

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  return paths[0]
}()

let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
  print("*** Fatal error: \(error)")
  NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}
