//
//  PetCoreRootView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//

import SwiftUI

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
                Text("Create Pet")
            case .updatePet:
                Text("Update Pet")
            case .petProfile:
                Text("Pet Profile")
        }
    }
}
