//
//  APISessionProviding.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation

protocol APISessionProviding {
  func execute<T: Codable>(_ requestProvider: RequestProviding) async throws -> T where T : Decodable
}
