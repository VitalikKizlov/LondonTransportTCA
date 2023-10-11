//
//  Information.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation

struct TravelInformation: Codable {
    var stopPoints: [BusStop]
}

extension TravelInformation: Equatable {}

struct BusStop: Codable, Hashable  {
    let id: String
    var naptanId: String
    var commonName: String
    var lines: [Lines]
}

extension BusStop: Identifiable {
    var identifier: UUID {
        return UUID()
    }
}

struct Lines: Codable, Hashable {
    var name: String
}
