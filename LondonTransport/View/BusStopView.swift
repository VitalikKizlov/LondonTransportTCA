//
//  BusStopView.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 11.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct BusStopView: View {
    let store: StoreOf<BusStopFeature>

    var body: some View {
        VStack {
            Text("Hello")
            Text("Location")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
