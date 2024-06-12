//
//  ProfileView.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import SwiftUI


struct ProfileView: View {
    
    @StateObject var LogInViewModel = LoginViewModel()
    @State private var shouldNavigateToLogin = false
    
    var body: some View {
        ZStack{
            Image("LJ Borrow login page background")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Logged in as \(UserSession.shared.username ?? "user")")
                Text("UUID: \(UserSession.shared.userUUID ?? 0)")
                Button(action: {
                    LogInViewModel.logout()
                    shouldNavigateToLogin = true
                    print(shouldNavigateToLogin)
                }) {
                    Text("Log Out")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(5)
                }
                .padding(.top, 50)
            }
        }
        
        NavigationStack {}
            .navigationDestination(isPresented: $shouldNavigateToLogin) {LoginView()
                .navigationBarBackButtonHidden(true)}
    }
}

#Preview {
    ProfileView()
}
