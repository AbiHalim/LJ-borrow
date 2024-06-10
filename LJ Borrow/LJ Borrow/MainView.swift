//
//  MainView.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            VStack {
                RecordsView()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 100)
                    .offset(y: -90)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: -5)
            }
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Home")
                }
            
            VStack {
                CreateView()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 100)
                    .offset(y: -90)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: -5)
            }
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Home")
                }
            
            VStack{
                ProfileView()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 100)
                    .offset(y: -90)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: -5)
            }
                .tabItem {
                    Image(systemName:"person.crop.circle.fill")
                    Text("Profile")
                }
            
            
        }
    }
}

#Preview {
    MainView()
}
