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
                        .hidden() // error message only for debugging
                } else {
                    Text("Bruh")
                        .foregroundColor(.red)
                        .offset(y: 25)
                        .hidden()
                }

                List(viewModel.records) { record in
                    VStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(1))
                            .frame(width: 350, height: 125)
                            .overlay(
                                VStack {
                                    Text(record.active != 0 ? "Active" : "Inactive")
                                        .font(.system(size: 25, weight: .bold, design: .rounded))
                                    Text("\(record.typeDescription) $\(record.adjustedAmount, specifier: "%.2f") on \(record.date_created)")
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    Text(record.associated_name)
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
                        if (record.confirmed == 0 && record.receiver_id == UserSession.shared.userUUID) {
                            HStack {
                                Button("Confirm") {
                                    Task {
                                        await viewModel.confirmAPIcall(record_id: record.id)
                                        await viewModel.fetchRecords()
                                    }
                                }
                                .padding(20)
                                .padding(.horizontal, 15)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .frame(width: 200, height: 50)
                                .padding(.trailing, -20)
                                .padding(.top, 5)
                                Button("Reject") {
                                    Task {
                                        await viewModel.rejectRecordAPIcall(record_id: record.id)
                                        await viewModel.fetchRecords()
                                    }
                                }
                                .padding(20)
                                .padding(.horizontal, 15)
                                .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                                .frame(width: 200, height: 50)
                                .padding(.top, 5)
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchRecords()
                    viewModel.errorMessage = ""
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
