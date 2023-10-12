//
//  BusStopService.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation
import ComposableArchitecture

protocol BusStopServiceProtocol {
    func getTravelInformation() async throws -> TravelInformation
    func getArrivals(_ id: String) async throws -> [ArrivalTime]
}

struct BusStopService: BusStopServiceProtocol {
    let session: APISessionProviding

    init(session: APISessionProviding = ApiSession()) {
        self.session = session
    }

    func getTravelInformation() async throws -> TravelInformation {
        let endpoint = BusStopEndpoint.stopPoint(coordinate: (latitude: 51.5, longitude: 0.12))
        return try await session.execute(endpoint)
    }

    func getArrivals(_ id: String) async throws -> [ArrivalTime] {
        let endpoint = BusStopEndpoint.arrivals(busStopID: id)
        return try await session.execute(endpoint)
    }
}

extension BusStopService: DependencyKey {
    static let liveValue = BusStopService()
}

extension DependencyValues {
  var busStopService: BusStopService {
    get { self[BusStopService.self] }
    set { self[BusStopService.self] = newValue }
  }
}
