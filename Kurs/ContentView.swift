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
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0.6823529412, blue: 0.7098039216, alpha: 1)))
            
            CurrencyListView(viewModel: viewModel)
            
            
            Text("\(viewModel.time)")
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0.6823529412, blue: 0.7098039216, alpha: 1)))
                .padding()
            Spacer()
            
            Button("Обновить") {
                viewModel.start()
            }
            .padding()
            .buttonStyle(RoundedButtonStyle())
        }
        .background(Color(#colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.1921568627, alpha: 1))) // 222831
                
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
            .foregroundColor(Color(red: 0.933, green: 0.933, blue: 0.933))
            .background(Color(#colorLiteral(red: 0, green: 0.6823529412, blue: 0.7098039216, alpha: 1)))
            .cornerRadius(20)
    }
}
