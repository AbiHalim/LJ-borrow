//
//  Record.swift
//  LJ Borrow
//
//  Created by Abi on 25/06/24.
//

import Foundation

struct Record: Identifiable, Codable {
    var id: Int
    var type: Int
    var creator_id: Int
    var receiver_id: Int
    var receiver_name: String
    var confirmed: Int
    var receiver_paid: Int
    var creator_paid: Int
    var active: Int
    var date_created: String
    var amount: Double
    var note: String
    
    var typeDescription: String {
        type != 0 ? "Borrowed" : "Lent"
    }
}
