//
//  DashboardView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//
import SwiftUI
import Factory
import SQAUtility

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: PetCoreViewModel
    @Injected(\SQAUtility.colorHelper) var colorHelper: ColorHelper
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    customDivider
                    
                    if viewModel.userPets.isEmpty {
                        emptyStateView
                    } else {
                        Text("Dashboard")
                            .padding(.top)
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack(spacing: 10) {
                            userImageComponent
                            VStack(alignment: .leading) {
                                Text("Hello,")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text(viewModel.user?.firstName ?? "")
                                    .font(.headline)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.isSuccess ? "Success" : "Error"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if viewModel.isSuccess {
                                print("SUCCESS")
                            }
                            viewModel.showAlert = false
                        }
                    )
                }
                .onAppear {
                    Task {
                        await fetchData()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
        }
    }
}

extension DashboardView {
    
    private func fetchData() async {
        let userResponse = await viewModel.getUser()
        if userResponse.isSuccess {
            let petsResponse = await viewModel.getUserPets()
        }
    }
    
}

extension DashboardView {
    
    private var customDivider: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.gray.opacity(0.2), location: 0),
                .init(color: Color.gray.opacity(0.5), location: 0.5),
                .init(color: Color.gray.opacity(0.2), location: 1.0)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: 1)
        .padding(.top, 8)
        .padding(.horizontal, 20)
    }
    
    private var userImageComponent: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(colorHelper.getColor(.blue500))
                .frame(width: 40, height: 40)
            
            if let imageUrl = viewModel.user?.image?.url {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        case .failure(_):
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        case .empty:
                            ProgressView()
                                .frame(width: 36, height: 36)
                        @unknown default:
                            EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {

            Spacer()
            
            Image("homeEmptySpace", bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 250)
            
            Text("Uh Oh!")
                .font(.title2)
            Text("Looks like you have no profiles set up at this moment, add your pet now.")
                .font(.subheadline)
            
            Spacer()
            
            SQAButton(title: "Add Pet", action: {
                print("Navigate to Add Pet Screen")
            }
          )
        }
        .padding()
    }
    
}

#Preview {
    DashboardView()
        .environmentObject(PetCoreViewModel())
}

