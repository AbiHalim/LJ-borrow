//
//  RecordsView.swift
//  LJ Borrow
//
//  Created by Abi on 07/06/24.
//

import SwiftUI

struct RecordsView: View {
    @StateObject var viewModel = RecordsViewModel()
    @State private var selectedRecord: Record?
    @State private var showingRecordDetails = false

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
                                RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 3)
                            )
                            .padding(.top, 15)
                            .onTapGesture {
                                selectedRecord = record
                                showingRecordDetails = true
                            }
                    }
                }
                .refreshable {
                    viewModel.fetchRecords()
                    viewModel.errorMessage = ""
                }
                .navigationTitle("Records")
            }

            if let record = selectedRecord, showingRecordDetails {
                VStack {
                    Text("Record Details")
                        .font(.headline)
                        .padding()

                    Text("Amount: \(record.adjustedAmount, specifier: "%.2f")")
                    Text("Type: \(record.typeDescription)")
                    Text("Associated Name: \(record.associated_name)")
                    Text("Note: \(record.note)")

                    HStack {
                        if record.creator_id == UserSession.shared.userUUID {
                            Button("Mark as Paid") {
                                // Implement mark as paid logic
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.trailing)

                            Button("Remind") {
                                // Implement remind logic
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        } else if record.receiver_id == UserSession.shared.userUUID {
                            Button("Mark as Paid") {
                                // Implement mark as paid logic
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()

                    Button("Close") {
                        showingRecordDetails = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .transition(.scale)
            }
        }
    }
}

struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView()
    }
}
