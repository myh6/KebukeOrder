//
//  APIService.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/13.
//

import Foundation

class APIService {
  static let shared = APIService()
  //AirTable
  private let baseAirURL = "https://api.airtable.com/v0/appQACu9oOd3UqMbv/tblwtAuirGDm6AGZ2"
  fileprivate let apiAirKey = "keyHbJOB2pN632WF6"

    /**you can also store your API key in a plist and use this function to retrive it.**/
//  func getAPIKey() -> String? {
//    guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else { return nil }
//    let url = URL(fileURLWithPath: path)
//    let data = try! Data(contentsOf: url)
//    guard let plist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String:String] else { return nil }
//    return plist.values.first
//  }



}

  //MARK: - AirTable
extension APIService {


  //GET data by group from API
  //baseURL:"https://api.airtable.com/v0/appUH1c6BD5hCJuCJ/order"
  func getDataByGroupFromAir(completion: @escaping ([Records]) -> Void) {
    var targetList: [Records] = []
    let urlString = URL(string: baseAirURL)
    print("DEBUG: urlString for getDataByGroupFromAir is \(urlString!)")
    var urlRequest = URLRequest(url: urlString!)
    urlRequest.setValue("Bearer \(apiAirKey)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      if let e = error {
        print("DEBUG: Error retriving data from API \(e.localizedDescription)")
      }

      if let data = data {
        do {
          let result = try JSONDecoder().decode(AirDrinksModel.self, from: data)
          print("DEBUG: all the data from API \(result.records.count)")
          targetList = []
          targetList = result.records.filter({
            $0.fields.group == Customer.group
          })
          completion(targetList)
        } catch {
          print("DEBUG: Error decoding data from API \(error.localizedDescription)")
        }
      }
    }.resume()
  }


  //GET the list of groups
  func getListOfGroupsFromAir(completion: @escaping (Array<String>) -> Void) {
    var group: Array<String> = []
    let urlString = URL(string: baseAirURL)
    print("DEBUG: urlString for getDataByGroupFromAir is \(urlString!)")
    var urlRequest = URLRequest(url: urlString!)
    urlRequest.setValue("Bearer \(apiAirKey)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      if let e = error {
        print("DEBUG: Error retriving data from API \(e.localizedDescription)")
      }

      if let data = data {
        do {
          let result = try JSONDecoder().decode(AirDrinksModel.self, from: data)
          print("DEBUG: all the data from API \(result.records.count)")
          group = []
          for index in 0...result.records.count - 1 {
            print("DEBUG: \(result.records[index].fields.group)")
            group.append(result.records[index].fields.group)
          }
          completion(group)

        } catch {
          print("DEBUG: Error decoding data from API \(error.localizedDescription)")
        }
      }
    }.resume()
  }

  //Delete order
  func deleteOrderInAir(id: String, completion: @escaping (Error?) -> Void) {

    var urlString = "\(baseAirURL)?records[]=\(id)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: urlString)
    print("DEBUG: urlString for getDataByGroupFromAir is \(urlString)")
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "DELETE"
    urlRequest.setValue("Bearer \(apiAirKey)", forHTTPHeaderField: "Authorization")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      if let e = error {
        print("DEBUG: Error deleting data \(e.localizedDescription)")
        completion(e)
      }
      completion(error)
    }.resume()

  }

  //POST order request to API
  //baseURL:"https://api.airtable.com/v0/appUH1c6BD5hCJuCJ/order"
  func postOrderToAir(completion: @escaping () -> Void) {

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let timeString = dateFormatter.string(from: Date())
    let data = AirDrinksModel(records: [Records(fields: Fields(group: Customer.group, name: Customer.name, drink: TempOrder.drinkName, cupSize: TempOrder.drinkVariation, iceLevel: TempOrder.drinkIceLevel, sweetLevel: TempOrder.drinkSweetLevel, addWhitePearl: TempOrder.addWhitePearl, addWaterPearl: TempOrder.addWaterPearl, number: TempOrder.drinksNumber, totalPrice: TempOrder.totalPrice, note: TempOrder.note, uploadTime: timeString))])
    let urlString = URL(string: baseAirURL)
    print("DEBUG: urlString for getDataByGroupFromAir is \(urlString!)")
    var urlRequest = URLRequest(url: urlString!)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("Bearer \(apiAirKey)", forHTTPHeaderField: "Authorization")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let data = try? JSONEncoder().encode(data) {
      urlRequest.httpBody = data
      URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        guard error == nil else {
          print("DEBUG: POST failed due to \(String(describing: error)).")
          return
        }
        print("DEBUG: Successfully POST to API")
        completion()
      }.resume()
    }

  }

}
