//
//  ViewModel.swift
//  Kurs
//
//  Created by ANSAR DAULETBAYEV on 03.05.2023.
//

import Combine
import SwiftUI

class ViewModel: ObservableObject {
    @Published var buyPriceUSD: String = ""
    @Published var buyPriceRUB: String = ""
    @Published var buyPriceEUR: String = ""
    @Published var buyPriceKRW: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        let symbols = ["USD", "EUR", "RUB", "KRW"]
        symbols.forEach { symbol in
            guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421&symbols=\(symbol),KZT") else {
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: RateResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    switch symbol {
                    case "USD":
                        let kztValue = response.rates["KZT"] ?? 0.0
                        let usdValue = response.rates["USD"] ?? 0.0
                        let result = kztValue / usdValue
                        self.buyPriceUSD = String(format: "%.4f", result)
                    case "EUR":
                        let kztValue = response.rates["KZT"] ?? 0.0
                        let eurValue = response.rates["EUR"] ?? 0.0
                        let result = kztValue / eurValue
                        self.buyPriceEUR = String(format: "%.4f", result)
                    case "RUB":
                        let kztValue = response.rates["KZT"] ?? 0.0
                        let rubValue = response.rates["RUB"] ?? 0.0
                        let result = kztValue / rubValue
                        self.buyPriceRUB = String(format: "%.4f", result)
                    case "KRW":
                        let kztValue = response.rates["KZT"] ?? 0.0
                        let krwValue = response.rates["KRW"] ?? 0.0
                        let result = kztValue / krwValue
                        self.buyPriceKRW = String(format: "%.4f", result)
                    default:
                        return
                    }
                })
                .store(in: &cancellables)
        }
    }
}

struct RateResponse: Decodable {
    let rates: [String: Double]
}
