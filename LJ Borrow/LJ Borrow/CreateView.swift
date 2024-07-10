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
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badAmount)))
                    .frame(width: 275, height: 40)
                    .padding(.top, 50)
                    .autocapitalization(.none)
                
                TextField("Enter other user's name", text: $viewModel.receiverName)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badReceiverName)))
                    .frame(width: 275, height: 40)
                    .padding(.top, 25)
                    .autocapitalization(.none)
                
                TextField("Add a note", text: $viewModel.note)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badNote)))
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
                        recordsViewModel.fetchRecords()
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
            ZStack {
                if viewModel.showingCreatedRecord {
                Color.clear
                  .ignoresSafeArea()

                ZStack {
                  VStack {
                      HStack {
                          Text("Succesfully created record")
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color.black)
                              .font(.system(size: 24))
                      }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 70)

                    HStack {
                      Button(action: {
                          viewModel.showingCreatedRecord = false
                          viewModel.amount = ""
                          viewModel.isBorrowing = true
                          viewModel.receiverName = ""
                          viewModel.note = ""
                      }, label: {
                        Text("Ok")
                          .foregroundColor(Color.white)
                          .padding(.top, 15)
                          .padding(.bottom, 15)
                          .padding(.trailing, 55)
                          .padding(.leading, 55)
                          .background(Color.blue)
                          .cornerRadius(5)
                          .shadow(color: Color.black.opacity(0.07), radius: 40, x: 0, y: 5)
                      })
                    }
                    .padding(.bottom, 0)
                    .padding(.horizontal, 35)
                    .padding(.top, 15)
                  }
                }
                .frame(height: 250)
                .frame(width: 350)
                .background(Color.white)
                .cornerRadius(25)
                .padding(.horizontal, 30)
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 5)

              }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
