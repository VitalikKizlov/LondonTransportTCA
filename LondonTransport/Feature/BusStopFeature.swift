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

    enum LoadingState {
        case notStarted
        case loading
        case loaded
        case error
    }

    struct State: Equatable {
        var loadingState: LoadingState = .notStarted
        var listOfBusStops: [BusStop] = []
        var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case onAppear
        case travelInformation(TaskResult<TravelInformation>)
        case alertDismissed
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.loadingState = .loading
            return .run { send in
                do {
                    let information = try await self.busStopService.getTravelInformation()
                    await send(.travelInformation(.success(information)))
                } catch {
                    await send(.travelInformation(.failure(error)))
                }
            }
        case .travelInformation(.success(let information)):
            state.loadingState = .loaded
            state.listOfBusStops = information.stopPoints
            return .none
        case .travelInformation(.failure(let error)):
            print("TravelInformation failed with error --- \(error)")
            state.loadingState = .error
            state.alert = AlertState(
                title: TextState("Error! Unable to retrieve your local bus stop data."),
                message: TextState(error.localizedDescription),
                dismissButton: .default(TextState("OK"), action: .send(.alertDismissed))
            )
            return .none
        case .alertDismissed:
            state.alert = .none
            return .none
        }
    }
}
