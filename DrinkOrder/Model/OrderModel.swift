//
//  OrderModel.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/14.
//

import Foundation

//Request
struct OrderModel: Codable {

  var group: String?
  var name: String?
  var drink: String?
  var cupSize: String?
  var iceLevel: String?
  var sweetLevel: String?
  var addWaterPearl: Bool
  var addWhitePearl: Bool
  var number: Int
  var totalPrice: Int
  var note: String?
  var uploadTime: String?

}

