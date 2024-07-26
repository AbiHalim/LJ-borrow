//
//  RecordsViewModel.swift
//  LJ Borrow
//
//  Created by Abi on 07/06/24.
//

import Foundation
import SwiftUI
import Combine

class RecordsViewModel: ObservableObject {
    @Published var records: [Record] = []
    @Published var errorMessage: String = ""
    
    private var cache: [Record] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadCachedRecords()
        fetchRecords()
    }
    
    private func loadCachedRecords() {
        if let data = UserDefaults.standard.data(forKey: "cachedRecords"),
           let cachedRecords = try? JSONDecoder().decode([Record].self, from: data) {
            self.records = cachedRecords
        }
    }
    
    private func cacheRecords(_ records: [Record]) {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: "cachedRecords")
        }
    }
    
    func fetchRecords() {
        let urlString = "http://localhost:5000/get_records/user_uuid=\(UserSession.shared.userUUID ?? "null")"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Record].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to fetch records: \(error)"
                case .finished:
                    break
                }
            }, receiveValue: { records in
                self.records = records
                self.cacheRecords(records)
            })
            .store(in: &self.cancellables)
    }
    
    func confirmAPIcall(record_id: String) async {
        let urlString = "http://localhost:5000/confirm_record/user_uuid=\(UserSession.shared.userUUID ?? "null")&record_uuid=\(record_id)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }
        
        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 404:
                        errorMessage = "Record not found"
                    case 409:
                        errorMessage = "Record already confirmed"
                    case 403:
                        errorMessage = "Access denied"
                    case 200:
                        errorMessage = "Succesfully created new record"
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
    
    func rejectRecordAPIcall(record_id: String) async {
        let urlString = "http://localhost:5000/reject_record/user_uuid=\(UserSession.shared.userUUID ?? "null")&record_uuid=\(record_id)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }
        
        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 404:
                        errorMessage = "Record not found"
                    case 409:
                        errorMessage = "Record already confirmed"
                    case 403:
                        errorMessage = "Access denied"
                    case 200:
                        errorMessage = "Succesfully rejected record"
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
    
    func markPaidAPIcall(record_id: String) async {
        let urlString = "http://localhost:5000/mark_paid/user_uuid=\(UserSession.shared.userUUID ?? "null")&record_uuid=\(record_id)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }
        
        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        break
                    case 409:
                        errorMessage = "Record already marked as paid"
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
    
    func remindAPIcall(record_id: String) async {
        let urlString = "http://localhost:5000/remind/record_uuid=\(record_id)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }
        
        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        break
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
    
    func clearReminderAPIcall(record_id: String) async {
        let urlString = "http://localhost:5000/clear_reminder/record_uuid=\(record_id)/"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Failed to create URL"
            return
        }
        
        do {
            let (_, response) = try await URLSession(configuration: .default).data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        break
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
