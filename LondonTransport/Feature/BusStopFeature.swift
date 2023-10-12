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
        var busStops: IdentifiedArrayOf<BusStop> = []
        @PresentationState var alert: AlertState<Action.Alert>?
        var selectedStop: BusStop?
        var isSheetPresented = false
        var path = StackState<ArrivalTimeFeature.State>()
    }

    enum Action: Equatable {
        case onAppear
        case travelInformation(TaskResult<TravelInformation>)
        case presentSheet(Bool)
        case path(StackAction<ArrivalTimeFeature.State, ArrivalTimeFeature.Action>)
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case retry
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loadingState = .loading
                return .run { send in
                    await send(.travelInformation(
                        TaskResult { try await self.busStopService.getTravelInformation() }
                    ))
                }
            case .travelInformation(.success(let information)):
                state.loadingState = .loaded
                state.busStops.append(contentsOf: information.stopPoints)
                return .none
            case .travelInformation(.failure(let error)):
                state.loadingState = .error
                state.alert = AlertState {
                    TextState("Error! Unable to retrieve your local bus stop data.")
                } actions: {
                    ButtonState(role: .cancel, action: .retry) {
                        TextState("Retry")
                    }
                } message: {
                    TextState(error.localizedDescription)
                }
                return .none
            case .presentSheet(let isPresented):
                state.isSheetPresented = isPresented
                state.selectedStop = isPresented ? state.selectedStop : .none
                return .none
            case .path:
                return .none
            case .alert(.presented(.retry)):
                state.loadingState = .loading
                return .run { send in
                    await send(.travelInformation(
                        TaskResult { try await self.busStopService.getTravelInformation() }
                    ))
                }
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
        .forEach(\.path, action: /Action.path) {
            ArrivalTimeFeature()
        }
    }
}
