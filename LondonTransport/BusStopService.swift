//
//  BusStopService.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation

protocol BusStopServiceProtocol {
    func getTopRated() async throws -> TravelInformation
}

struct BusStopService: BusStopServiceProtocol {
    func getTopRated() async throws -> TravelInformation {
        let session = ApiSession()
        let provider = BusStopEndpoint.stopPoint(coordinate: (latitude: 51.5, longitude: 0.12))
        return try await session.execute(provider)
    }
}
