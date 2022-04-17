//
//  AirDrinksModel.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/17.
//

import Foundation

struct AirDrinksModel: Codable {

  var records: [Records]

}

struct Records: Codable {

  var fields: Fields
  var id: String?
}

struct Fields: Codable {

  var group: String
  var name: String
  var drink: String
  var cupSize: String
  var iceLevel: String
  var sweetLevel: String
  var addWhitePearl: Bool?
  var addWaterPearl: Bool?
  var number: Int
  var totalPrice: Int
  var note: String?
  var uploadTime: String
}


struct AirDrinksGroupModel: Codable {

  var records: [GroupRecords]

}

struct GroupRecords: Codable {

  var fields: GroupFields
  var id: String?
  
}

struct GroupFields: Codable {

  var group: String
  var name: String
}
