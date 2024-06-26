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
        let urlString = "http://localhost:5000/get_records/user_uuid=\(UserSession.shared.userUUID ?? 0)"
        
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
}
