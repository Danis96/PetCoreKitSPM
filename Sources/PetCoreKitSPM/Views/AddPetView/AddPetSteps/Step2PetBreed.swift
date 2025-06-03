//
//  Step2PetDetails.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI
import Shared_kit

struct Step2PetBreed: View {
     
    @EnvironmentObject private var petVM: PetCoreViewModel
    @EnvironmentObject private var breedVM: BreedKitViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text(PetCoreKitSPMStrings.petCoreAddS2ChooseBreedTitle.replacingOccurrences(of: "{petType}", with: petVM.petType.capitalized))
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(PetCoreKitSPMStrings.petCoreAddS2PetBreedLabel)
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
                                breedVM.selectBreed(breedID: breed.id ?? "")
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
        .withSharedKitPreviewDependecies()
}
