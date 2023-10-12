//
//  ArrivalTimeFeature.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 11.10.2023.
//

import Foundation
import ComposableArchitecture

struct ArrivalTimeFeature: Reducer {

    // MARK: - Dependencies

    @Dependency(\.busStopService) var busStopService

    enum LoadingState {
        case notStarted
        case loading
        case loaded
        case error
    }

    struct State: Equatable {
        let busStop: BusStop
        var loadingState: LoadingState = .notStarted
        var arrivalTimes: [ArrivalTime] = []
        var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case onAppear
        case arrivalTime(TaskResult<[ArrivalTime]>)
        case alertDismissed
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loadingState = .loading
                let id = state.busStop.id
                return .run { send in
                    do {
                        let arrivals = try await self.busStopService.getArrivals(id)
                        await send(.arrivalTime(.success(arrivals)))
                    } catch {
                        await send(.arrivalTime(.failure(error)))
                    }
                }
            case .arrivalTime(.success(let arrivals)):
                state.loadingState = .loaded
                state.arrivalTimes = arrivals.sorted(by: { $0.timeToStation < $1.timeToStation })
                return .none
            case .arrivalTime(.failure(let error)):
                state.loadingState = .error
                state.alert = AlertState(
                    title: TextState("Error! Unable to retrieve bus arrival times."),
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
}
