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
    
    var body: some Scene {
        WindowGroup {
            if LogInViewModel.loggedIn {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}
