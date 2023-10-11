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

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .arrivalTime(let taskResult):
            return .none
        case .alertDismissed:
            return .none
        }
    }
}
