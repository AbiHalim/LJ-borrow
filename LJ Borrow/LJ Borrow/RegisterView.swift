//
//  SecondView.swift
//  LJ Borrow
//
//  Created by Abi on 02/06/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    @State var showLoginView = false
    
    var body: some View {
        ZStack{
            Image("LJ Borrow login page background")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Image("LJ Borrow Register Page Graphics V1.2")
                    .scaleEffect(0.7)
                    .padding(.bottom, -75)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.red)
                        .offset(y: -15)
                } else {
                    Text("Bruh")
                        .foregroundColor(Color.red)
                        .offset(y: -15)
                        .hidden()
                }
                
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badUsername)))
                    .frame(width: 275, height: 40)
                
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badEmail)))  // turns red if email doesnt match format
                    .frame(width: 275, height: 40)
                    .padding()
                
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badPassword )))
                    .frame(width: 275, height: 40)
                
                SecureField("Re-enter Password", text: $viewModel.reEnterPassword)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(viewModel.badReEnterPassword )))   //   red if doesnt match
                    .frame(width: 275, height: 40)
                    .padding()
                
                Button("Register")    {
                    Task{
                        await viewModel.register_accountAPIcall(username: viewModel.username, email: viewModel.email, password: viewModel.password, re_enter_password: viewModel.reEnterPassword)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .frame(width: 275, height: 40)
                .padding()
                
                //Button("Test") {viewModel.showingRegisteredAccount = true}
                
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Sign in now")
                        .foregroundColor(.black)
                        .padding(.top, 5)
                        .underline()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding(.bottom, 125)
            
            NavigationLink("", destination:  LoginView(), isActive: $showLoginView)
            ZStack {
                if viewModel.showingRegisteredAccount {
                Color.clear
                  .ignoresSafeArea()

                ZStack {
                  VStack {
                      HStack {
                          Text("Succesfully registered account")
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color.black)
                              .font(.system(size: 24))
                      }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 70)

                    HStack {
                      Button(action: {
                        showLoginView = true
                      }, label: {
                        Text("Go to Log In")
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
    
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
