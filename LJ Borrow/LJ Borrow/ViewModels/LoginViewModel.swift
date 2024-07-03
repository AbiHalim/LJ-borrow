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
    
    init() {
            let userSession = UserSession.shared
            self.username = userSession.username ?? ""
            self.loggedIn = userSession.username != nil
            if (loadToken().2 != nil) {
                loggedIn = true
            }
        }
    
    func saveCredentials(token: String, username: String, userUUID: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        UserSession.shared.saveUserCredentials(username: username, userUUID: userUUID)
    }

    func loadToken() -> (token: String?, username: String?, userUUID: String?) {
        
        let token = UserDefaults.standard.string(forKey: "authToken")
        let username = UserDefaults.standard.string(forKey: "username")
        let userUUID = UserDefaults.standard.string(forKey: "userUUID")
        return (token, username, userUUID)
    }
    
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
            let (data, response) = try await URLSession(configuration: .default).data(from: url)

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
                        // Print the raw data response
                        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("jsonResponse: \(jsonResponse)")
                            if let token = jsonResponse["token"] as? String,
                               let userUUID = jsonResponse["userUUID"] as? String {
                                saveCredentials(token: token, username: username, userUUID: userUUID)
                                DispatchQueue.main.async {
                                    self.loggedIn = true
                                }
                            } else {
                                errorMessage = "Failed to retrieve token or user information"
                                print("Error: Missing token or userUUID in response")
                            }
                        } else {
                            errorMessage = "Failed to parse JSON response"
                            print("Error: Failed to parse JSON response")
                        }
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
    
    func logout() {
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserSession.shared.clearUserCredentials()
            DispatchQueue.main.async {
                self.loggedIn = false
            }
        }
    
}

