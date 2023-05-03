//
//  ContentView.swift
//  Kurs
//
//  Created by ANSAR DAULETBAYEV on 03.05.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Курсы валют")
                .font(.title)
                .padding()
            
            List {
                HStack {
                    Text("Валюта")
                        .font(.headline)
                    Spacer()
                    Text("TNG")
                        .font(.headline)
                }
                
                Divider()
                
                HStack {
                    Text("USD")
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(viewModel.buyPriceUSD)")
                }
                
                Divider()
                
                HStack {
                    Text("EUR")
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(viewModel.buyPriceEUR)")
                }
                
                Divider()
                
                HStack {
                    Text("WON")
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(viewModel.buyPriceKRW)")
                }
                
                Divider()
                
                HStack {
                    Text("RUS")
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(viewModel.buyPriceRUB)")
                }
                
                Divider()
            }
            Button("Обновить") {
                viewModel.start()
            }
            .padding()
        }
        .background(Color.white)
        .onAppear {
            self.viewModel.start()
        }
    }
}


class ViewModel: ObservableObject {
    @Published var buyPriceUSD: String = ""
    @Published var buyPriceRUB: String = ""
    @Published var buyPriceEUR: String = ""
    @Published var buyPriceKRW: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        // Получение отношения USD к KZT
        guard let usdToKztUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421&symbols=USD,KZT") else { return }
        URLSession.shared.dataTaskPublisher(for: usdToKztUrl)
            .map { $0.data }
            .decode(type: RateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.buyPriceUSD = "\(response.rates["KZT"] ?? 0.0)"
            })
            .store(in: &cancellables)
        
        // Получение отношения EUR к KZT
        guard let eurToKztUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421&symbols=EUR,KZT") else { return }
        URLSession.shared.dataTaskPublisher(for: eurToKztUrl)
            .map { $0.data }
            .decode(type: RateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                let kztValue = response.rates["KZT"] ?? 0.0
                let eurValue = response.rates["EUR"] ?? 0.0
                let result = kztValue / eurValue
                self.buyPriceEUR = String(result)
            })
            .store(in: &cancellables)
        
        // Получение отношения RUB к KZT
        guard let rubToKztUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421&symbols=RUB,KZT") else { return }
        URLSession.shared.dataTaskPublisher(for: rubToKztUrl)
            .map { $0.data }
            .decode(type: RateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                let kztValue = response.rates["KZT"] ?? 0.0
                let rubValue = response.rates["RUB"] ?? 0.0
                let result = kztValue / rubValue
                self.buyPriceRUB = String(result)
            })
            .store(in: &cancellables)
        
        // Получение отношения KRW к KZT
        guard let krwToKztUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=11aaedca74904e10abdb9cfa224a7421&symbols=KRW,KZT") else { return }
        URLSession.shared.dataTaskPublisher(for: krwToKztUrl)
            .map { $0.data }
            .decode(type: RateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                let kztValue = response.rates["KZT"] ?? 0.0
                let krwValue = response.rates["KRW"] ?? 0.0
                let result = kztValue / krwValue
                self.buyPriceKRW = String(result)
            })
            .store(in: &cancellables)
    }
}

struct RateResponse: Decodable {
    let rates: [String: Double]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
