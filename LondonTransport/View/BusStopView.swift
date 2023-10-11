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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .opacity(viewStore.state.loadingState == .loading ? 1 : 0)

                    List {
                        ForEach(viewStore.state.listOfBusStops, id: \.id) { stop in
                            Button {
                                //viewStore.send(.selectStop(stop: stop))
                                print("stop is \(stop)")
                            } label: {
                                BusStopRow(busStop: stop)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}
