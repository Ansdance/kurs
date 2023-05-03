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
            
            CurrencyListView(viewModel: viewModel)
            
            Text("\(viewModel.time)")
                .padding()
            Spacer()
            
            Button("Обновить") {
                viewModel.start()
            }
            .padding()
            .buttonStyle(RoundedButtonStyle())
        }
        .background(Color.white)
        .onAppear {
            viewModel.start()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .cornerRadius(10)
    }
}
