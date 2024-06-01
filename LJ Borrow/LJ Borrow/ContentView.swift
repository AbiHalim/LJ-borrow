//
//  ContentView.swift
//  Login Page UI
//
//  Created by Ryan Chan on 30/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("LJ Borrow login page background")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                    VStack {
                        Image("LJ Borrow Login Page Cartoon 1")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -125)
                        Text("Record and Confirm")
                            .padding(.vertical, -50)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Text("your Transactions")
                            .padding(.vertical, -35)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Image("LJ Borrow Arrow Bubble")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -100)
                        Text("Swipe to continue reading")
                            .padding(.top, -25)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                    }
                        .tag(1)
                    VStack {
                        Image("LJ Borrow Login Page Cartoon 2")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -125)
                        Text("Track Money")
                            .padding(.vertical, -50)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Text("Borrowed and Lent")
                            .padding(.vertical, -35)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Image("LJ Borrow Arrow Bubble")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -100)
                        Text("Swipe to continue reading")
                            .padding(.top, -25)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                    }
                        .tag(2)
                    VStack {
                        Image("LJ Borrow Login Page Cartoon 3")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -125)
                        Text("Get Reminders")
                            .padding(.vertical, -50)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Text("for your Debts")
                            .padding(.vertical, -35)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Image("LJ Borrow Arrow Bubble")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -100)
                        Text("Swipe to continue reading")
                            .padding(.top, -25)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                    }
                        .tag(3)
                    VStack {
                        Image("LJ Borrow Login Page Cartoon 4")
                            .imageScale(.small)
                            .scaleEffect(0.3)
                            .padding(.vertical, -125)
                        Text("Send Reminders")
                            .padding(.vertical, -50)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Text("to your Debtor")

                            .padding(.vertical, -35)
                                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                    Image("LJ Borrow Arrow Bubble")
                                                        .imageScale(.small)
                                                        .scaleEffect(0.3)
                                                        .padding(.vertical, -100)
                                                    Text("Swipe to continue reading")
                                                        .padding(.top, -25)
                                                        .font(.system(size: 14, weight: .regular, design: .rounded))
                                                }
                                                    .tag(4)
                                                VStack {
                                                    Image("LJ Borrow Logo V2.1")
                                                        .scaleEffect(0.9)
                                                        .padding(.bottom, -35)
                                                    Text("LJ Borrow")
                                                        .font(.system(size: 30, weight: .bold, design: .rounded))
                                                    Text("Record Your Debts.")
                                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                        .padding(.top, 1)
                                                    Text("Secure Your Friendship.")
                                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                }
                                                    .tag(5)
                                            }
                                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                                .background(Color.clear)
                                            TextField("Email Address or ID", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                                                .padding()
                                                .background(Color.white)
                                                .overlay(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.gray,
                                                            lineWidth: 1.5))
                                                .frame(width: 275, height: 40)
                                                .padding()
                                            Button("Sign In") {
                                                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                                            }
                                            .padding()
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .overlay(RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray,
                                                        lineWidth: 1.5))
                                            .frame(width: 275, height: 40)
                                        }
                                        .padding(.bottom, 200)
                                    }
                                }
                            }
                            #Preview {
                                ContentView()
                            }
