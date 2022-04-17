//
//  DateUtility.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/13.
//

import Foundation

class DateUtility {

  static let instance = DateUtility()

  func getTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    let timeString = dateFormatter.string(from: Date())
    return timeString
  }

}
