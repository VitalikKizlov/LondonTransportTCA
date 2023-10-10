//
//  APISession.swift
//  LondonTransport
//
//  Created by Vitalii Kizlov on 10.10.2023.
//

import Foundation

struct ApiSession: APISessionProviding {
    func execute<T>(_ requestProvider: RequestProviding) async throws -> T where T : Decodable {
        do {
            let (data, response) = try await URLSession.shared.data(for: requestProvider.urlRequest())
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.responseNotValid
            }

            if 400 ..< 499 ~= httpResponse.statusCode {
                if httpResponse.statusCode == 403 {
                    throw APIError.forbidden
                }

                if httpResponse.statusCode == 404 {
                    throw APIError.notFound
                }

                throw APIError.clientError(httpResponse.statusCode)
            }

            let decoder = JSONDecoder()

            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decodingError(data)
            }
        } catch {
            guard let err = error as? URLError else {
                throw APIError.generic(error)
            }

            if err.errorCode == NSURLErrorNotConnectedToInternet {
                throw APIError.noInternetConnection
            }

            if err.errorCode == NSURLErrorTimedOut {
                throw APIError.requestTimedOut
            }

            throw APIError.generic(error)
        }
    }
}
