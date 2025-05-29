//
//  PetCoreRootView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//

import SwiftUI
import Shared_kit

struct PetCoreRootView: View {
    
    @StateObject private var coordinator = PetCoreCoordinator.shared
    
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            DashboardView()
                .navigationDestination(for: PetCoreViewRoute.self) { endpoint in
                    PetCoreKitDestinationView(endpoint: endpoint)
                        .environmentObject(coordinator.petCoreViewModel)
                }
        }
        .environmentObject(coordinator)
        .environmentObject(coordinator.petCoreViewModel)
    }
}


struct PetCoreKitDestinationView: View {
    let endpoint: PetCoreViewRoute
    
    var body: some View {
        switch endpoint {
            case .dashboard:
                DashboardView()
            case .createPet:
                AddPetView()
                    .environmentObject(BreedKitCoordinator.shared.breedKitViewModel)
                    .environmentObject(ImageKitCoordinator.shared.imageKitViewModel)
            case .updatePet:
                Text("Update Pet")
            case .petProfile:
                PetProfileView()
                    .environmentObject(BreedKitCoordinator.shared.breedKitViewModel)
                    .environmentObject(ImageKitCoordinator.shared.imageKitViewModel)
                    .environmentObject(BreedKitCoordinator.shared)
        }
    }
}
