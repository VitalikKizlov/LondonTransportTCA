//
//  LondonTransportApp.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct LondonTransportApp: App {
    var body: some Scene {
        WindowGroup {
            BusStopView(store: Store(initialState: BusStopFeature.State(), reducer: {
                BusStopFeature()
            }))
        }
    }
}
