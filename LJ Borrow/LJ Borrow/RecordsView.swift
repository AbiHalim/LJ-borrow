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
                } else {
                    Text("Bruh")
                        .foregroundColor(.red)
                        .offset(y: 25)
                        .hidden()
                }

                List(viewModel.records) { record in
                    VStack {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(record.active == 1 ? Color.clear : Color.gray.opacity(0.3))
                                .frame(width: 350, height: 125)
                                .overlay(
                                    VStack {
                                        Text("$\(record.adjustedAmount, specifier: "%.2f")")
                                            .font(.system(size: 25, weight: .bold, design: .rounded))
                                        Text("\(record.typeDescription) on \(record.date_created)")
                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        Text(record.associated_name)
                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        Text(record.note)
                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        Text(record.active == 1 ? "Active" : "Inactive")
                                            .font(.system(size: 20, weight: .regular, design: .rounded))
                                    }
                                    .foregroundColor(.black)
                                    .padding()
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 3)
                                )
                                .padding(.top, 15)
                                .onTapGesture {
                                    if record.active == 1 {
                                        selectedRecord = record
                                        showingRecordDetails = true
                                        if record.type == 0 && record.creator_id == UserSession.shared.userUUID || record.type == 1 && record.receiver_id == UserSession.shared.userUUID {
                                            Task {
                                                await viewModel.clearReminderAPIcall(record_id: record.id)
                                                viewModel.fetchRecords()
                                            }
                                        }
                                    }
                                }

                            if record.reminder == 1 && (record.type == 0 && record.creator_id == UserSession.shared.userUUID || record.type == 1 && record.receiver_id == UserSession.shared.userUUID) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 20, height: 20)
                                    .offset(x: 10, y: 25)
                                    .padding(.top, -15)
                                    .padding(.leading, -15)
                            }
                        }

                        
                        if (record.confirmed == 0 && record.receiver_id == UserSession.shared.userUUID) {
                            HStack {
                                Button("Confirm") {
                                    Task {
                                        await viewModel.confirmAPIcall(record_id: record.id)
                                        viewModel.fetchRecords()
                                    }
                                }
                                .padding(20)
                                .padding(.horizontal, 15)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .frame(width: 200, height: 50)
                                .padding(.top, 5)
                                Button("Reject") {
                                    Task {
                                        await viewModel.rejectRecordAPIcall(record_id: record.id)
                                        viewModel.fetchRecords()
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
                    viewModel.fetchRecords()
                    viewModel.errorMessage = ""
                }
                .navigationTitle("Records")
                .scrollContentBackground(.hidden)
            }

            if let record = selectedRecord, showingRecordDetails {
                VStack {
                    Text("Record Details")
                        .font(.headline)
                        .padding()

                    Text("Amount: $\(record.adjustedAmount, specifier: "%.2f")")
                    Text("Type: \(record.typeDescription)")
                    Text("User: \(record.associated_name)")
                    Text("Note: \(record.note)")

                    HStack {
                        
                        if record.creator_id == UserSession.shared.userUUID {
                            Button(action: {
                                Task {
                                    await viewModel.markPaidAPIcall(record_id: record.id)
                                    viewModel.fetchRecords()
                                    showingRecordDetails = false
                                }
                            }) {
                                Text("Mark as Paid")
                                    .padding()
                                    .background(record.creator_paid == 1 ? Color.gray : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(record.creator_paid == 1)
                        } else if record.receiver_id == UserSession.shared.userUUID {
                            Button(action: {
                                Task {
                                    await viewModel.markPaidAPIcall(record_id: record.id)
                                    viewModel.fetchRecords()
                                    showingRecordDetails = false
                                }
                            }) {
                                Text("Mark as Paid")
                                    .padding()
                                    .background(record.receiver_paid == 1 ? Color.gray : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(record.receiver_paid == 1)
                        }
                        
                        if record.type == 1 && record.creator_id == UserSession.shared.userUUID || record.type == 0 && record.receiver_id == UserSession.shared.userUUID {
                            Button("Remind") {
                                Task {
                                    await viewModel.remindAPIcall(record_id: record.id)
                                    viewModel.fetchRecords()
                                    showingRecordDetails = false
                                }
                            }
                            .disabled(record.reminder == 1)
                            .padding()
                            .background(record.reminder == 1 ? Color.gray : Color.blue)
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
