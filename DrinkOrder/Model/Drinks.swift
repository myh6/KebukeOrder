//
//  Drinks.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/10.
//

import Foundation

struct Item: Codable {

  let name: String
  let description: String
  let menu: String
  let price: Price

}

struct Price: Codable {

  let medium: Int
  let large: Int?

}

final class Drinks {

  static let shared = Drinks()
  func getDBMenu(completion: @escaping([Item]?) -> Void ) {
    let url = Bundle.main.url(forResource: "Drinks", withExtension: "plist")!
            if let data = try? Data(contentsOf: url), let menu = try? PropertyListDecoder().decode([Item].self, from: data) {
                completion(menu)
            } else {
                completion(nil)
            }
  }

}
