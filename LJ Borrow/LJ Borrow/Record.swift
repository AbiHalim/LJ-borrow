//
//  Record.swift
//  LJ Borrow
//
//  Created by Abi on 25/06/24.
//

import Foundation

struct Record: Identifiable, Codable {
    var id: String
    var type: Int
    var creator_id: String
    var receiver_id: String
    var associated_name: String
    var confirmed: Int
    var receiver_paid: Int
    var creator_paid: Int
    var active: Int
    var date_created: String
    var amount: Double
    var note: String
    
    var typeDescription: String {
        (type == 1 && creator_id == UserSession.shared.userUUID || type == 0 && receiver_id == UserSession.shared.userUUID) ? "Lent" : "Borrowed"
    }
    
    var adjustedAmount: Double {
        amount / 100
    }
}
