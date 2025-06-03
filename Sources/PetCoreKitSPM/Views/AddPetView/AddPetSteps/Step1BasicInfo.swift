//
//  Step1BasicInfo.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI
import SQAUtility

struct Step1BasicInfo: View {
    @EnvironmentObject private var petVM: PetCoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PetCoreKitSPMStrings.petCoreAddS1BasicsTitle)
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(PetCoreKitSPMStrings.petCoreAddS1PetNameLabel)
                    .font(.headline)
                
                SQATextField(placeholder: PetCoreKitSPMStrings.petCoreAddS1PetNamePlaceholder, text: $petVM.petName)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(PetCoreKitSPMStrings.petCoreAddS1PetTypeLabel)
                    .font(.headline)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
//                    ForEach(PetCoreDeveloperPreview.shared.previewAnimalType, id: \.self) { petType in
                    ForEach(petVM.petTypeList, id: \.self) { petType in
                        PetTypeCardComponent(
                            type: petType.type ?? "",
                            image: petType.image ?? "",
                            isSelected: petVM.petType == petType.type ?? "",
                            onTap: {
                                petVM.setPetType(petType.type?.uppercased() ?? "")
                            }
                        )
                    }
                }
                
            }
            Spacer()
        }
        .dismissKeyboardOnTap()
    }
    
}

#Preview {
    Step1BasicInfo()
        .withPetCorePreviewDependecies()
} 
