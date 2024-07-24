//
//  UserSearchPopup.swift
//  LJ Borrow
//
//  Created by Abi on 23/07/24.
//

import SwiftUI

struct UserSearchPopup: View {
    @Binding var searchText: String
    var users: [String] // Assume this is a list of user names
    var onClose: () -> Void

    var body: some View {
        VStack {
            TextField("Search user", text: $searchText)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                .autocapitalization(.none)

            List {
                ForEach(users.filter { $0.contains(searchText) }, id: \.self) { user in
                    Text(user)
                        .onTapGesture {
                            searchText = user
                            onClose()
                        }
                }
            }
            .listStyle(PlainListStyle())

            Button("Close") {
                onClose()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .transition(.scale)
    }
}
