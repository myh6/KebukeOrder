//
//  NetworkError.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/17.
//

import Foundation

enum NetWorkError:Error {
    case requestFailed
    case invalidurl
    case invalidResponse
    case invalidData
    case invalidJsonFormat
    case other(String)

}
