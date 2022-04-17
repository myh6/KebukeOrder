//
//  TempOrder.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/12.
//

import Foundation

class TempOrder {

  static var drinkName = ""
  static var drinkVariation = ""
  static var drinkIceLevel = ""
  static var drinkSweetLevel = ""
  static var drinksNumber = 0
  static var addWaterPearl = false
  static var addWhitePearl = false
  static var totalPrice = 0
  static var note = ""
  static var time = ""

  static func clearOrder() {

    drinkName = ""
    drinkVariation = ""
    drinkIceLevel = ""
    drinkSweetLevel = ""
    drinksNumber = 0
    addWaterPearl = false
    addWhitePearl = false
    totalPrice = 0
    note = ""
    time = ""
    
  }

}
