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
               
               Button("Обновить") {
                   viewModel.start()
               }
               .padding()
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
