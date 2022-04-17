//
//  APIService.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/13.
//

import Foundation

class APIService {
  //SheetDB
  private let baseURL = "https://sheetdb.io/api/v1/"
  static let shared = APIService()
  //AirTable
  private let baseAirURL = "https://api.airtable.com/v0/appUH1c6BD5hCJuCJ/tblAAZcfEvvAOToqg"
  fileprivate let apiAirKey = "keyrUxEFB5MHFlToK"


  func getAPIKey() -> String? {
    guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else { return nil }
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    guard let plist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String:String] else { return nil }
    return plist.values.first
  }

//  func getGroups(completion: @escaping (Array<String>?) -> Void) {
//    var groups: Array<String> = []
//    let key = getAPIKey()
//    guard key != nil else { return }
//    let urlString = baseURL + key!
//    print("DEBUG: urlString is \(urlString)")
//    let url = URL(string: urlString)
//    var urlRequest = URLRequest(url: url!)
//    urlRequest.httpMethod = "GET"
//    urlRequest.setValue("applicaion/json", forHTTPHeaderField: "Content-Type")
//
//    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//        if let data = data {
//            do {
//              let result = try JSONDecoder().decode([[String: String]].self, from: data)
//                print("DEBUG: API result: \(result)")
//                for element in result {
//                  groups.append(element["group"]!)
//                }
//                print("DEBUG: getGroups result: \(groups)")
//              completion(groups)
//            } catch {
//              print("DEBUG: Error retriving groups \(error)")
//              completion(groups)
//            }
//        }
//    }.resume()
//  }

//  func getDataFromGroup(completion: @escaping ([[String:String]], Error?) -> Void) {
//    var targetList: [[String: String]] = []
//    let key = getAPIKey()
//    guard key != nil else { return }
//    let urlString = baseURL + key!
//    print("DEBUG: urlString is \(urlString)")
//    let url = URL(string: urlString)
//    var urlRequest = URLRequest(url: url!)
//    urlRequest.httpMethod = "GET"
//    urlRequest.setValue("applicaion/json", forHTTPHeaderField: "Content-Type")
//
//    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//        if let data = data {
//            do {
//                let result = try JSONDecoder().decode([[String: String]].self, from: data)
//                print("DEBUG: all the data from API \(result)")
//                targetList = result.filter({
//                $0["group"] == Customer.group
//              })
//              completion(targetList, error)
//            } catch {
//              print(error)
//              completion(targetList, error)
//            }
//        }
//    }.resume()
//
//  }

//  func postOrder(completion: @escaping () -> Void) {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//    let timeString = dateFormatter.string(from: Date())
//    let data = OrderModel(group: Customer.group,
//                          name: Customer.name,
//                          drink: TempOrder.drinkName,
//                          cupSize: TempOrder.drinkVariation,
//                          iceLevel: TempOrder.drinkIceLevel,
//                          sweetLevel: TempOrder.drinkSweetLevel,
//                          addWaterPearl: TempOrder.addWaterPearl,
//                          addWhitePearl: TempOrder.addWhitePearl,
//                          number: TempOrder.drinksNumber,
//                          totalPrice: TempOrder.totalPrice,
//                          note: TempOrder.note,
//                          uploadTime: timeString)
//    let key = getAPIKey()
//    guard key != nil else { return }
//    let urlString = baseURL + key!
//    print("DEBUG: urlString is \(urlString)")
//    let url = URL(string: urlString)
//    var urlRequest = URLRequest(url: url!)
//    urlRequest.httpMethod = "POST"
//    urlRequest.setValue("appliction/json", forHTTPHeaderField: "Content-Type")
//
//    if let data = try? JSONEncoder().encode(data) {
//      urlRequest.httpBody = data
//      URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//        guard error == nil else {
//          print("DEBUG: POST failed due to \(String(describing: error)).")
//          return
//        }
//        if let data = data,
//           let status = try? JSONDecoder().decode([String:Int].self, from: data),
//           status["created"] == 1 {
//          print("DEBUG: POST successfully.")
//          completion()
//        }
//      }.resume()
//    }
//  }
//
//  func deleteOrder(completion: @escaping (Error?) -> Void) {
//    let key = getAPIKey()
//    guard key != nil else { return }
//    let urlString = baseURL + key! + "/name/\(Customer.name)?limit=1"
//    let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//    var urlRequest = URLRequest(url: url!)
//    urlRequest.httpMethod = "DELETE"
//    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//      if let data = data,
//         let status = try? JSONDecoder().decode([String:Int].self, from: data), status["deleted"] != nil {
//        print("ok")
//        completion(error)
//      } else {
//        print("error")
//        completion(error)
//      }
//    }.resume()
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
  //baseURL:"https://api.airtable.com/v0/appUH1c6BD5hCJuCJ/order"
  //https://api.airtable.com/v0/appUH1c6BD5hCJuCJ/order?fields%5B%5D=group&fields%5B%5D=name
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
