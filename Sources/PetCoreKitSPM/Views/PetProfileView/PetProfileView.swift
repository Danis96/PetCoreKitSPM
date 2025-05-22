//
//  PetProfileView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 22. 5. 2025..
//
import SwiftUI
import Factory
import Shared_kit

struct PetProfileView: View {
    
    @EnvironmentObject var petVM: PetCoreViewModel
    @EnvironmentObject var breedVM: BreedKitViewModel
    
    var body: some View {
        Shared_kit.startBreedKit {}
        .onAppear {
            Task {
                try await getInitialData()
            }
        }
    }
}

extension PetProfileView {
    private func getInitialData() async throws {
        let response = try await breedVM.fetchBreeds(petSpecie: petVM.selectedPet?.petType ?? "")
        if response.isSuccess {
            breedVM.selectBreed(breedID: petVM.selectedPet?.breedID ?? "")
        }
    }
}


#Preview {
    PetProfileView()
        .withBreedKitPreviewDependecies()
}
