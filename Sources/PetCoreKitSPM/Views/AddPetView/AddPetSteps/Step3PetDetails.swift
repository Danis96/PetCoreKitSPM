//
//  Step3HealthInfo.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI
import Factory
import SQAUtility
import Shared_kit

struct Step3PetDetails: View {
    @EnvironmentObject private var petVM: PetCoreViewModel
    @Injected(\SQAUtility.colorHelper) var colorHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PetCoreKitSPMStrings.petCoreAddS3TellUsMoreTitle)
                    .font(.title2)
                    .fontWeight(.semibold)
            
            VStack(alignment: .center, spacing: 12) {
                ImageKitCoordinator.shared.start(
                    selectedImage: $petVM.petImage,
                    type: .petProfile,
                    allowInternalUse: false,
                )
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(PetCoreKitSPMStrings.petCoreAddS3DescriptionLabel)
                    .font(.headline)
                
                TextEditor(text: $petVM.petDescription)
                    .frame(minHeight: 60)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            Spacer()
        }
        .dismissKeyboardOnTap()
        .onAppear {
            petVM.setPetImage(nil)
        }
    }
}

#Preview {
    Step3PetDetails()
    .withPetCorePreviewDependecies()
}
