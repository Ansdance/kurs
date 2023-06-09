//
//  ViewModel.swift
//  Kurs
//
//  Created by ANSAR DAULETBAYEV on 03.05.2023.
//

import Combine
import SwiftUI
import Alamofire

class ViewModel: ObservableObject {
    @Published var buyPriceUSD: String = ""
    @Published var buyPriceRUB: String = ""
    @Published var buyPriceEUR: String = ""
    @Published var buyPriceKRW: String = ""
    @Published var time: String = ""
    
    
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        let symbols = ["USD", "EUR", "RUB", "KRW"]
        symbols.forEach { symbol in
            guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421&symbols=\(symbol),KZT") else {
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: ResponseData.self, decoder: JSONDecoder())
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
        fetchExchangeRate()
    }
    
    
    func fetchExchangeRate() {
        let url = "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421"
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any], let timestamp = json["timestamp"] as? Double else { return }
                self.formattedString(for: timestamp)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func formattedString(for timestamp: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.time = dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    //    func fetchExchangeRate() {
    //        guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421") else { return }
    //        URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let data = data {
    //                do {
    //                    let decoder = JSONDecoder()
    //                    decoder.keyDecodingStrategy = .convertFromSnakeCase
    //                    let exchangeRateData = try decoder.decode(ResponseData.self, from: data)
    //                    self.formattedString(for: exchangeRateData.timestamp)
    //                } catch {
    //                    print("Error decoding JSON: \(error)")
    //                }
    //            }
    //        }.resume()
    //    }
}

struct ResponseData: Decodable {
    let rates: [String: Double]
    let timestamp: Double
}
