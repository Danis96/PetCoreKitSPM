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
    @EnvironmentObject var coordinator: PetCoreCoordinator
    @Injected(\SQAUtility.colorHelper) var colorHelper: ColorHelper
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    customDivider
                    
                    if viewModel.userPets.isEmpty {
                        emptyStateView
                    } else {
                        activeDashboardView
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack(spacing: 10) {
                            userImageComponent
                            VStack(alignment: .leading) {
                                Text(PetCoreKitSPMStrings.petCoreDashGreeting)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text(viewModel.user?.firstName ?? "")
                                    .font(.headline)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            coordinator.navigate(to: .createPet)
                        }) {
                            Image(systemName: "plus.app")
                                .font(.title3)
                                .foregroundColor(colorHelper.getColor(.blue500))
                        }
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.isSuccess ? PetCoreKitSPMStrings.petCoreDashSuccessTitle : PetCoreKitSPMStrings.petCoreDashErrorTitle),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text(PetCoreKitSPMStrings.petCoreDashAlertButtonOK)) {
                            if viewModel.isSuccess {
                                print(PetCoreKitSPMStrings.petCoreDashSuccessMessage)
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
    
    public var customDivider: some View {
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
    
    private var activeDashboardView: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer().frame(height: 5)
            activePetCardList
        }
    }
    
    private var activePetCardList: some View {
        
        Section(header: HStack(spacing: 5) {
            Text(PetCoreKitSPMStrings.petCoreDashActivePetProfilesTitle)
            Text("\(viewModel.userPets.count)")
                .fontWeight(.bold)
                .foregroundStyle(colorHelper.getColor(.blue500))
                .padding(.all, 5)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                
        } .padding(.horizontal, 20))
        {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.userPets, id: \.id) { pet in
                        ActivePetCardViewComponent(
                            petName: pet.name ?? "",
                            petBreed: pet.breedName ?? "",
                            petType: pet.petType ?? "",
                            petImage: pet.image?.url ?? "",
                            onTap: {
                                viewModel.setSelectedPet(pet)
                                coordinator.navigate(to: .petProfile)
                            }
                        )
                        .frame(width: UIScreen.main.bounds.width - 40)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollTargetBehavior(.paging)
        }
    }
    
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {

            Spacer()
            
            Image("homeEmptySpace", bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 250)
            
            Text(PetCoreKitSPMStrings.petCoreDashEmptyStateTitle)
                .font(.title2)
            Text(PetCoreKitSPMStrings.petCoreDashEmptyStateMessage)
                .font(.subheadline)
            
            Spacer()
            
            SQAButton(title: PetCoreKitSPMStrings.petCoreDashAddPetButton, action: {
                coordinator.navigate(to: .createPet)
            }
          )
        }
        .padding()
    }
    
}

#Preview {
    DashboardView()
        .withSharedKitPreviewDependecies()
        .environmentObject(PetCoreViewModel())
}

