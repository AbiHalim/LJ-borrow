//
//  CreateViewModel.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import Foundation

class CreateViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var isBorrowing: Bool = true
    @Published var receiverName: String = ""
    @Published var note: String = ""
    @Published var errorMessage: String = ""

    func newRecordAPIcall() async {
        guard let amountInt = Int(amount) else {
            errorMessage = "Please enter a valid amount"
            return
        }
        
        guard !receiverName.isEmpty else {
            errorMessage = "Please enter the other user's name"
            return
        }
        
        guard !note.isEmpty else {
            errorMessage = "Please add a note"
            return
        }
        
        errorMessage = ""
        let urlString = "http://localhost:5000/new_record/type=\(isBorrowing ? 0 : 1)&creator_id=\(UserSession.shared.userUUID ?? 0)&receiver_name=\(receiverName)&amount=\(amountInt)&note=\(note)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }

        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        print("Created new record")
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
