//
//  APIError.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation

enum APIError: Error {
    case decodingError(Data)
    case noInternetConnection
    case requestTimedOut
    case generic(Error)
    case responseNotValid
    case forbidden
    case notFound
    case clientError(Int)
}
