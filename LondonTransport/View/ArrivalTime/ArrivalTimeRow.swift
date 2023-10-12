//
//  ArrivalTimeRow.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 12.10.2023.
//

import SwiftUI

struct ArriveTimeRow: View {
    var arrivalTime: ArrivalTime
    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            Text(arrivalTime.stationName)
            HStack {
                VStack(alignment: .leading) {
                    Text("Bus")
                        .bold()
                    Spacer()
                    Text(arrivalTime.lineName)
                        .foregroundColor(.white)
                }.padding(.trailing, 100)

                VStack(alignment: .leading) {
                    Text("Arrival Time")
                        .bold()
                    Spacer()
                    Text(arrivalTime.timeInMinutes)
                        .foregroundColor(.white)

                }
            }.padding(.bottom, 10)
                .padding(.top, 10)
                .frame(width: screenWidth - 10)
                .background(Color.accentColor)
        }.padding(.top, 4)
            .background(Color.white)
    }
}
