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
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    if viewStore.state.loadingState == .loading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        if viewStore.state.busStops.isEmpty {
                            Text("There is no information currently available!")
                                .font(.system(size: 18, weight: .medium))
                                .multilineTextAlignment(.center)
                        } else {
                            List {
                                ForEach(viewStore.state.busStops) { stop in
                                    NavigationLink(state: ArrivalTimeFeature.State(busStop: stop)) {
                                        BusStopRow(busStop: stop)
                                    }
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                .navigationTitle("Bus stops")
                .alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        } destination: { store in
            ArrivalTimeView(store: store)
        }
    }
}
