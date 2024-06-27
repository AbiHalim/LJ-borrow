//
//  CreateView.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import SwiftUI

struct CreateView: View {
    
    @StateObject var viewModel = CreateViewModel()
    @StateObject var recordsViewModel = RecordsViewModel()
    
    var body: some View {
        ZStack {
            Image("LJ Borrow main page background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("LJ Borrow Create Page Cartoon 1")
                    .scaleEffect(0.45)
                    .padding(.top, -175)
                    .padding(.bottom, -215)
                Text("Simply Sign.")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.top, 60)
                Text("Simply Friendship.")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.top, -10)
                    .padding(.bottom, -100)
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .offset(y: 25)
                } else {
                    Text("Bruh")
                        .foregroundColor(.red)
                        .offset(y: 25)
                        .hidden()
                }
                
                // Amount Input
                DecimalTextField(text: $viewModel.amount, placeholder: "$0.00")
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                    .padding(.top, 50)
                    .autocapitalization(.none)
                
                TextField("Enter other user's name", text: $viewModel.receiverName)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                    .padding(.top, 25)
                    .autocapitalization(.none)
                
                TextField("Add a note", text: $viewModel.note)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                    .padding(.top, 25)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                
                Picker("Type", selection: $viewModel.isBorrowing) {
                    Text("Borrowed").tag(true)
                    Text("Lent").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 1)
                .frame(maxWidth: 275)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1.5)
                        )
                
                Button(action: {
                    Task {
                        await viewModel.newRecordAPIcall()
                        await recordsViewModel.fetchRecords()
                    }
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .frame(width: 275, height: 40)
                        .padding()
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
