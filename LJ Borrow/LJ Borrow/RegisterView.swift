//
//  SecondView.swift
//  LJ Borrow
//
//  Created by Abi on 02/06/24.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        ZStack{
            Image("LJ Borrow login page background")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Image("LJ Borrow Register Page Graphics V1.2")
                    .scaleEffect(0.7)
                    .padding(.bottom, -75)
                TextField("Username", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                TextField("Email", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                    .padding()
                TextField("Password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                TextField("Re-enter Password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                    .padding()
                Button("Register")    {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1.5))
                .frame(width: 275, height: 40)
                .padding()
                NavigationLink(destination: ContentView()) {
                    Text("Already have an account? Sign in now")
                        .foregroundColor(.black)
                        .padding(.top, 5)
                        .underline()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding(.bottom, 125)
        }
    }
}
    
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
