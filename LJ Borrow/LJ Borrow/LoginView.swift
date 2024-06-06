//
//  ContentView.swift
//  Login Page UI
//
//  Created by Ryan Chan on 30/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("LJ Borrow login page background")
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                        VStack {
                            Image("LJ Borrow Login Page Cartoon 1")
                                .scaleEffect(0.3)
                                .padding(.top, 380)
                                .padding(.bottom, -175)
                            Text("Record and Confirm")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text("your Transactions")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.bottom, -100)
                            Image("LJ Borrow Arrow Bubble V2.0")
                                .imageScale(.small)
                                .scaleEffect(0.6)
                                .padding(.top, -50)
                                .padding(.bottom, 400)
                        }
                        .tag(1)
                        VStack {
                            Image("LJ Borrow Login Page Cartoon 2")
                                .scaleEffect(0.3)
                                .padding(.top, 380)
                                .padding(.bottom, -175)
                            Text("Track Money")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text("Borrowed and Lent")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.bottom, -100)
                            Image("LJ Borrow Arrow Bubble V2.0")
                                .imageScale(.small)
                                .scaleEffect(0.6)
                                .padding(.top, -50)
                                .padding(.bottom, 400)
                        }
                        .tag(2)
                        VStack {
                            Image("LJ Borrow Login Page Cartoon 3")
                                .scaleEffect(0.3)
                                .padding(.top, 380)
                                .padding(.bottom, -175)
                            Text("Get Reminders")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text("for your Debts")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.bottom, -100)
                            Image("LJ Borrow Arrow Bubble V2.0")
                                .imageScale(.small)
                                .scaleEffect(0.6)
                                .padding(.top, -50)
                                .padding(.bottom, 400)
                        }
                        .tag(3)
                        VStack {
                            Image("LJ Borrow Login Page Cartoon 4")
                                .scaleEffect(0.3)
                                .padding(.top, 380)
                                .padding(.bottom, -175)
                            Text("Send Reminders")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text("to your Debtor")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.bottom, -100)
                            Image("LJ Borrow Arrow Bubble V2.0")
                                .imageScale(.small)
                                .scaleEffect(0.6)
                                .padding(.top, -50)
                                .padding(.bottom, 400)
                        }
                        .tag(4)
                        VStack {
                            Image("LJ Borrow Logo V2.1")
                                .scaleEffect(0.9)
                                .padding(.bottom, -35)
                            Text("LJ Borrow")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                            Text("Record Your Debts.")
                                .font(.system(size: 20, weight:
                                        .semibold, design: .rounded))
                                .padding(.top, 1)
                            Text("Secure Your Friendships.")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                        .tag(5)
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .background(Color.clear)
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1.5))
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.red, lineWidth: CGFloat(wrongUsername))) // turns red if wrong username
                        .frame(width: 275, height: 40)
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1.5))
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.red, lineWidth: CGFloat(wrongPassword))) // turns red if wrong password
                        .frame(width: 275, height: 40)
                        .padding()
                    Button("Sign In")    {
                        Task{
                            await loginAPIcall(username: username, password: password)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .frame(width: 275, height: 40)
                    .padding()
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account? Register now")
                            .foregroundColor(.black)
                            .padding(.top, 5)
                            .underline()
                            .navigationBarBackButtonHidden(true)
                    }
                    
                    NavigationLink(destination: Text("You are logged in as \(username)"), isActive: $showingLoginScreen) {EmptyView()}
                    
                }
                .padding(.bottom, 160)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    func loginAPIcall(username: String, password: String) async {
        
        //setting up request
        let url = URL(string: "http://localhost:5000//log_in/username=\(username)&password_hash=\(password)/")!
        print("url: \(url)")

        do {
            let (_, response) = try await URLSession(configuration: URLSessionConfiguration.default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 404:
                        wrongUsername = 2
                        print("wrong username, 404")
                    case 403:
                        wrongPassword = 2
                        print("wrong password, 403")
                    case 200:
                        wrongUsername = 0
                        wrongPassword = 0
                        showingLoginScreen = true
                        print("logged in")
                    default:
                        print("Received status code \(httpResponse.statusCode)")
                }
            } else {
                print("invalid response received")
            }

        } catch {
            print("Failed to perform API call: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
