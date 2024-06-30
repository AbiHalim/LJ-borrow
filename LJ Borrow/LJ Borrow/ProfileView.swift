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
            Image("LJ Borrow main page background")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                Image("LJ Borrow Profile View Cartoon 1")
                    .scaleEffect(0.6)
                    .padding(.top, -75)
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(1))
                    .frame(width: 300, height: 100)
                    .overlay(
                        VStack {
                            Text("Logged in as \(UserSession.shared.username ?? "user")")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Text("User ID: \(UserSession.shared.userUUID ?? 0)")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                            .foregroundColor(.black)
                            .padding()
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) .stroke(Color.gray, lineWidth: 3)
                    )
                    .padding(.horizontal)
                    .padding(.top, -50)
                Button(action: {
                    LogInViewModel.logout()
                    shouldNavigateToLogin = true
                }
                ) {
                    Text("Log Out")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(5)
                }
                .padding(.top, 0)
            
            NavigationStack {}
                .navigationDestination(isPresented: $shouldNavigateToLogin) {LoginView()
                    .navigationBarBackButtonHidden(true)}
                .frame(height:0)
            }
        }
    }
}

#Preview {
    ProfileView()
}
