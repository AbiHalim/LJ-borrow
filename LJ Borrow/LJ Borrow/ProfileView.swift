//
//  ProfileView.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Image("LJ Borrow login page background")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Profile")
            }
        }
    }
}

#Preview {
    ProfileView()
}
