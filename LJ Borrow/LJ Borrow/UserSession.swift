//
//  UserSession.swift
//  LJ Borrow
//
//  Created by Abi on 11/06/24.
//
//  Stores current logged in user's information (username, UUID)

import Foundation

class UserSession {
    static let shared = UserSession()

    private init() {
        loadUserCredentials()
    }

    var username: String?
    var userUUID: String?

    func loadUserCredentials() {
        self.username = UserDefaults.standard.string(forKey: "username")
        self.userUUID = UserDefaults.standard.string(forKey: "userUUID")
    }

    func saveUserCredentials(username: String, userUUID: String) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(userUUID, forKey: "userUUID")
        self.username = username
        self.userUUID = userUUID
    }

    func clearUserCredentials() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "userUUID")
        self.username = nil
        self.userUUID = nil
    }
}
