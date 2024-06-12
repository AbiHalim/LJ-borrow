//
//  MainView.swift
//  LJ Borrow
//
//  Created by Abi on 10/06/24.
//

import SwiftUI

struct MainView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            VStack {
                RecordsView()
            }
                .tabItem {
                    Image(systemName: "doc.plaintext")
                }
            
            VStack {
                CreateView()
            }
                .tabItem {
                    Image("Create Button")
                }
            
            VStack{
                ProfileView()
            }
                .tabItem {
                    Image(systemName:"person.circle.fill")
                }
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(.gray)
    }
}

#Preview {
    MainView()
}
