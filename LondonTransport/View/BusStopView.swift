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
                        List {
                            ForEach(viewStore.state.busStops, id: \.id) { stop in
                                NavigationLink(state: ArrivalTimeFeature.State(busStop: stop)) {
                                    BusStopRow(busStop: stop)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        } destination: { store in
            ArrivalTimeView(store: store)
        }
    }
}
