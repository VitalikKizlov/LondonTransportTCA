//
//  BusStopEndpoint.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation

typealias Coordinate = (latitude: Double, longitude: Double)

enum BusStopEndpoint {
    case stopPoint(coordinate: Coordinate)
    case arrivals(busStopID: String)
}

extension BusStopEndpoint: RequestProviding {
    var method: HTTPMethod {
        return .get
    }

    var host: String {
        return "api.tfl.gov.uk"
    }

    var path: String {
        switch self {
        case .stopPoint:
            return "/Stoppoint"
        case .arrivals(let busStopID):
            return "/Stoppoint/\(busStopID)/" + "/Arrivals"
        }
    }

    var header: [String: String] {
        [:]
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .stopPoint(let coordinates):
            return [
                URLQueryItem(name: "lat", value: String(describing: coordinates.latitude)),
                URLQueryItem(name: "lon", value: String(describing: coordinates.longitude)),
                URLQueryItem(name: "stoptypes", value: "NaptanPublicBusCoachTram"),
                URLQueryItem(name: "radius", value: "500"),
                URLQueryItem(name: "app_key", value: Constants.transportForLondonKey)
        ]
        case .arrivals:
            return []
        }
    }

    func urlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Can't create URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print("Request ----", request)
        return request
    }
}
