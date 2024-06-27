//
//  LJ_BorrowApp.swift
//  LJ Borrow
//
//  Created by Abi on 01/06/24.
//

import SwiftUI

@main
struct LJ_BorrowApp: App {
    
    @StateObject var LogInViewModel = LoginViewModel()
    
    init() {
            _ = UserSession.shared // This will load the user credentials at app launch
        }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
