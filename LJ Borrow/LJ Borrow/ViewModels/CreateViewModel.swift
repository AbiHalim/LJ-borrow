//
//  CreateViewModel.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import Foundation

class CreateViewModel: ObservableObject {
    @Published var amount = ""
    @Published var isBorrowing = true
    @Published var receiverName = ""
    @Published var note = ""
    @Published var errorMessage = ""
    @Published var showingCreatedRecord = false
    @Published var badAmount = 0
    @Published var badReceiverName = 0
    @Published var badNote = 0
    @Published var showingUserSearchPopup = false
    @Published var usernames: [String] = []

    func fetchUsernames() {
        guard let url = URL(string: "http://localhost:5000/get_usernames/") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([String].self, from: data) {
                    DispatchQueue.main.async {
                        self.usernames = decodedResponse
                    }
                } else {
                    print("Failed to decode response")
                }
            } else {
                print("Request failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    func newRecordAPIcall() async {
        errorMessage = ""
        badAmount = 0
        badReceiverName = 0
        badNote = 0
        
        guard let amountDouble = Double(amount), amountDouble < Double(Int.max) else {
            errorMessage = "Amount is too large"
            badAmount = 2
            return
        }
        
        guard let amountDouble = Double(amount), amountDouble >= 0 else {
            errorMessage = "Please enter a valid amount"
            badAmount = 2
            return
        }
        
        let scaledAmount = Int(amountDouble * 100) // Scale by 100 to handle cents
        
        guard !receiverName.isEmpty else {
            errorMessage = "Please enter the other user's name"
            badReceiverName = 2
            return
        }
        
        guard !note.isEmpty else {
            errorMessage = "Please enter a note"
            badNote = 2
            return
        }
        
        let formattedNote = note.isEmpty ? "null" : note
        
        let urlString = "http://localhost:5000/new_record/type=\(isBorrowing ? 0 : 1)&creator_id=\(UserSession.shared.userUUID ?? "null")&receiver_name=\(receiverName)&amount=\(scaledAmount)&note=\(formattedNote)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }

        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 400:
                        errorMessage = "Receiver must be different from creator"
                        badReceiverName = 2
                    case 404:
                        errorMessage = "Target user not found"
                        badReceiverName = 2
                    case 200:
                        showingCreatedRecord = true
                        errorMessage = ""
                        badAmount = 0
                        badReceiverName = 0
                        badNote = 0
                    default:
                        errorMessage = "Received status code \(httpResponse.statusCode)"
                }
            } else {
                errorMessage = "Invalid response received"
            }
        } catch {
            errorMessage = "Failed to perform API call: \(error)"
        }
    }
}
