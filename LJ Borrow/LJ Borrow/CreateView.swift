//
//  CreateView.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import SwiftUI

struct CreateView: View {
    
    @StateObject var viewModel = CreateViewModel()
    
    var body: some View {
        ZStack {
            Image("LJ Borrow login page background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("New Record")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 50)
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .offset(y: -15)
                } else {
                    Text("Bruh")
                        .foregroundColor(.red)
                        .offset(y: -15)
                        .hidden()
                }
                
                TextField("$0.00", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: 320)
                    .multilineTextAlignment(.trailing)
                
                Picker("Type", selection: $viewModel.isBorrowing) {
                    Text("Borrowed").tag(true)
                    Text("Lent").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: 320)
                
                TextField("Enter other user's name", text: $viewModel.receiverName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: 320)
                
                TextField("Add a note", text: $viewModel.note)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: 320)
                
                Button(action: {
                    Task {
                        await viewModel.newRecordAPIcall()
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 320)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
