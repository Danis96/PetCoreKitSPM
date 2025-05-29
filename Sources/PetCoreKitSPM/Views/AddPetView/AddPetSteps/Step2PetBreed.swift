//
//  Step2PetDetails.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI

struct Step2PetBreed: View {
    @EnvironmentObject private var petVM: PetCoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Choose your \(petVM.petType.capitalized) breed")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Pet Breed")
                    .font(.headline)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
//                    ForEach(PetCoreDeveloperPreview.shared.previewABreedList, id: \.self) { breed in
                        ForEach(petVM.breeds, id: \.self) { breed in
                        PetTypeCardComponent(
                            type: breed.name, image: breed.referenceImage,
                            isSelected: petVM.petBreed == breed.name ?? "",
                            onTap: {
                                petVM.setPetBreed(breed.name, breedID: breed.id)
                            }
                        )
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    Step2PetBreed()
        .withPetCorePreviewDependecies()
}
