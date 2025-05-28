//
//  Step5Review.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 28. 5. 2025..
//


import SwiftUI

struct Step5Review: View {
    @EnvironmentObject private var petVM: PetCoreViewModel
    let petAge: Int
    let petWeight: Double
    let petDescription: String
    let selectedImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Review your pet's information")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(spacing: 12) {
                    reviewRow(title: "Name", value: petVM.petName ?? "")
                    reviewRow(title: "Type", value: petVM.petType)
                    reviewRow(title: "Breed", value: petVM.petBreed)
                    reviewRow(title: "Age", value: "\(petAge) years")
                    reviewRow(title: "Weight", value: String(format: "%.1f kg", petWeight))
                    
                    if !petDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notes:")
                                .font(.headline)
                            Text(petDescription)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private func reviewRow(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    Step5Review(
        petAge: 3,
        petWeight: 12.5,
        petDescription: "Very friendly and energetic dog",
        selectedImage: nil
    )
    .withPetCorePreviewDependecies()
}
