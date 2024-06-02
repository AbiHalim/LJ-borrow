//
//  SecondView.swift
//  LJ Borrow
//
//  Created by Abi on 02/06/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var reEnterPassword = ""
    @State private var email = ""
    @State private var badEmail = 0
    @State private var notMatchingPassword = 0
    @State private var showingRegisteredAccount = false
    
    var body: some View {
        ZStack{
            Image("LJ Borrow login page background")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Image("LJ Borrow Register Page Graphics V1.2")
                    .scaleEffect(0.7)
                    .padding(.bottom, -75)
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(badEmail)))  // turns red if email doesnt match format
                    .frame(width: 275, height: 40)
                    .padding()
                SecureField("Password", text: $password)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .frame(width: 275, height: 40)
                SecureField("Re-enter Password", text: $reEnterPassword)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1.5))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: CGFloat(notMatchingPassword)))   //   red if doesnt match
                    .frame(width: 275, height: 40)
                    .padding()
                Button("Register")    {
                    Task{
                        await register_accountAPIcall(username: username, email: email, password: password, re_enter_password: reEnterPassword)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .frame(width: 275, height: 40)
                .padding()
                NavigationLink(destination: ContentView()) {
                    Text("Already have an account? Sign in now")
                        .foregroundColor(.black)
                        .padding(.top, 5)
                        .underline()
                        .navigationBarBackButtonHidden(true)
                }
                
                NavigationLink(destination: Text("Succesfully registered new account!"), isActive: $showingRegisteredAccount) {EmptyView()}
                
            }
            .padding(.bottom, 125)
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    
    func register_accountAPIcall(username: String, email: String, password: String, re_enter_password: String) async {
        
        if validateEmail(enteredEmail: email) {
            print("valid email")
            badEmail = 0
            
            if password == re_enter_password {
                notMatchingPassword = 0
                //setting up post request
                let url = URL(string: "http://localhost:5000//register_account/username=\(username)&email=\(email)&password_hash=\(password)/")!

                do {
                    let (_, response) = try await URLSession(configuration: URLSessionConfiguration.default).data(from: url)
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                            case 200:
                                print("registered account")
                                showingRegisteredAccount = true
                            default:
                                print("Received status code \(httpResponse.statusCode)")
                        }
                    } else {
                        print("invalid response received")
                    }

                } catch {
                    print("Failed to perform API call: \(error)")
                }
                
                } else {
                    print("Passwords don't match")
                    notMatchingPassword = 1
                }
                
        } else {
            print("Invalid email")
            badEmail = 1
        }
    }
    
}
    
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
