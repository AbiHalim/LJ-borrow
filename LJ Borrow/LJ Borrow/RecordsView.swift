//
//  RecordsView.swift
//  LJ Borrow
//
//  Created by Abi on 07/06/24.
//

import SwiftUI

struct RecordsView: View {
    @StateObject var viewModel = RecordsViewModel()

    var body: some View {
        ZStack {
            Image("LJ Borrow main page background")
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Records")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 50)

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(viewModel.records) { record in
                    HStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(1))
                            .frame(width: 350, height: 125)
                            .overlay(
                                VStack {
                                    Text(record.active != 0 ? "Active" : "Inactive")
                                        .font(.system(size: 25, weight: .bold, design: .rounded))
                                    Text("\(record.typeDescription) & \(record.amount, specifier: "%.2f") & \(record.date_created)")
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    Text(record.receiver_name)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                         Text(record.note)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                }
                                    .foregroundColor(.black)
                                    .padding()
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20) .stroke(Color.gray, lineWidth: 3)
                            )
                            .padding(.top, 15)
                    }
                }
                .refreshable {
                    await viewModel.fetchRecords()
                }
                .navigationTitle("Records")
            }
        }
    }
}

struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView()
    }
}
