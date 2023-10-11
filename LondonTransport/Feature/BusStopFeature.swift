//
//  BusStopFeature.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 11.10.2023.
//

import Foundation
import ComposableArchitecture

struct BusStopFeature: Reducer {
    
    // MARK: - Dependencies

    @Dependency(\.busStopService) var busStopService

    struct State: Equatable {
        
    }

    enum Action: Equatable {
        case onAppear
        case travelInformation(TaskResult<TravelInformation>)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                do {
                    let information = try await self.busStopService.getTravelInformation()
                    await send(.travelInformation(.success(information)))
                } catch {
                    await send(.travelInformation(.failure(error)))
                }
            }
        case .travelInformation(.success(let information)):
            print("TravelInformation is \(information)")
            return .none
        case .travelInformation(.failure(let error)):
            print("TravelInformation failed with error --- \(error)")
            return .none
        }
    }
}
