//
//  LoginViewViewModel.swift
//  LJ Borrow
//
//  Created by Abi on 06/06/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var wrongUsername = 0
    @Published var wrongPassword = 0
    @Published public var loggedIn = false
    @Published var errorMessage = ""
    
    init() {}
    
    func loginAPIcall(username: String, password: String) async {
        wrongUsername = 0
        wrongPassword = 0
        errorMessage = ""
        
        guard !username.isEmpty else {
            errorMessage = "Please enter a username"
            wrongUsername = 2
            return ()
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            wrongPassword = 2
            return ()
        }
        
        
        let url = URL(string: "http://localhost:5000//log_in/username=\(username)&password_hash=\(password)/")!
        print("url: \(url)")

        do {
            let (_, response) = try await URLSession(configuration: URLSessionConfiguration.default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 404:
                        wrongUsername = 2
                        errorMessage = "User not found"
                        print("wrong username, 404")
                    case 403:
                        wrongPassword = 2
                        errorMessage = "Incorrect password"
                        print("wrong password, 403")
                    case 200:
                        wrongUsername = 0
                        wrongPassword = 0
                        loggedIn = true
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

