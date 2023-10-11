//
//  BusStopRow.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 11.10.2023.
//

import Foundation
import SwiftUI

struct BusStopRow: View {
    let busStop: BusStop
    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            VStack {
                Text(busStop.commonName)
                    .bold()
                    .foregroundColor(.white)
                Text(getListOfBus(with: busStop.lines))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 10)
            .padding(.top, 10)
            .frame(width: screenWidth - 10)
            .background(Color.gray)

        }
        .padding(.top, 4)
        .background(Color.white)
    }

    private func getListOfBus(with list: [Lines]) -> String {
        var busLines = ""
        for line in list {
            busLines += line.name + ", "
        }
        return busLines
    }
}
