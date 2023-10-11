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
        var alert: AlertState<Action>?
        var selectedStop: BusStop?
        var isSheetPresented = false
        var path = StackState<ArrivalTimeFeature.State>()
    }

    enum Action: Equatable {
        case onAppear
        case travelInformation(TaskResult<TravelInformation>)
        case alertDismissed
        case presentSheet(Bool)
        case path(StackAction<ArrivalTimeFeature.State, ArrivalTimeFeature.Action>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
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
                state.busStops.append(contentsOf: information.stopPoints)
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
            case .presentSheet(let isPresented):
                state.isSheetPresented = isPresented
                state.selectedStop = isPresented ? state.selectedStop : .none
                return .none
            case .path(let stackAction):
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            ArrivalTimeFeature()
        }
    }
}
