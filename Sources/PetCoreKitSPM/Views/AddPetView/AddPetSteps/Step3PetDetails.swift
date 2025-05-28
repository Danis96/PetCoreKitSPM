//
//  Step3HealthInfo.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI

struct Step3PetDetails: View {
    @EnvironmentObject private var petVM: PetCoreViewModel
    @Binding var petAge: Int
    @Binding var selectedImage: UIImage?
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tell us more about your pet")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Breed")
                    .font(.headline)
                
                TextField("Enter breed", text: $petVM.petBreed)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Age (years)")
                    .font(.headline)
                
                Stepper(value: $petAge, in: 0...30) {
                    Text("\(petAge) years old")
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Pet Photo")
                    .font(.headline)
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                VStack {
                                    Image(systemName: "camera")
                                        .font(.title2)
                                    Text("Add Photo")
                                        .font(.caption)
                                }
                                    .foregroundColor(.gray)
                            )
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    Step3PetDetails(
        petAge: .constant(2),
        selectedImage: .constant(nil),
        showingImagePicker: .constant(false)
    )
    .withPetCorePreviewDependecies()
}
