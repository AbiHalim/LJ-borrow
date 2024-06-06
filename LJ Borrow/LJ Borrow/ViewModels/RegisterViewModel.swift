//
//  RegisterViewViewModel.swift
//  LJ Borrow
//
//  Created by Abi on 06/06/24.
//

import Foundation

class RegisterViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    @Published var reEnterPassword = ""
    @Published var email = ""
    @Published var badUsername = 0
    @Published var badEmail = 0
    @Published var badPassword = 0
    @Published var badReEnterPassword = 0
    @Published var showingRegisteredAccount = false
    @Published var errorMessage = ""
    
    init() {}
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func register_accountAPIcall(username: String, email: String, password: String, re_enter_password: String) async {
        
        badUsername = 0
        badEmail = 0
        badPassword = 0
        badReEnterPassword = 0
        errorMessage = ""
        
        guard !username.isEmpty else {
            errorMessage = "Please enter a username"
            badUsername = 2
            return ()
        }
        
        guard validateEmail(enteredEmail: email) else {
            badEmail = 2
            errorMessage = "Please enter a valid email address"
            return ()
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter a password"
            badPassword = 2
            return ()
        }
        
        guard password == reEnterPassword else {
            badReEnterPassword = 2
            errorMessage = "Passwords do not match"
            return ()
        }
        
        badReEnterPassword = 0
        //setting up request
        let url = URL(string: "http://localhost:5000//register_account/username=\(username)&email=\(email)&password_hash=\(password)/")!
        
        do {
            let (_, response) = try await URLSession(configuration: URLSessionConfiguration.default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 409:
                        badUsername = 2
                        errorMessage = "Username already taken"
                    case 200:
                        showingRegisteredAccount = true
                        print("registered account")
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
