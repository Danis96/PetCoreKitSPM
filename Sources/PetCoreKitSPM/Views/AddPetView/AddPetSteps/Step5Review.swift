//
//  Step5Review.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 28. 5. 2025..
//

import SwiftUI
import Shared_kit

struct Step5Review: View {
    @EnvironmentObject private var petVM: PetCoreViewModel
    @EnvironmentObject private var breedVM: BreedKitViewModel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Review your pet's information")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    if petVM.petImage != nil {
                        petImageComponent
                    }
                    
                    HStack {
                        reviewRow(title: "Breed", value: petVM.petBreed)
                        Shared_kit.startCustomBreedKit(width: 30, height: 30, icon: "pawprint") {}
                    }
                }

                VStack(spacing: 12) {
                    reviewRow(title: "Name", value: petVM.petName ?? "")
                    reviewRow(title: "Age", value: petVM.calculateAge(from: petVM.dateToString(petVM.petBirthday)) ?? "Unknown age")
                    reviewRow(title: "Weight", value: "\(petVM.petWeight) kg")
                    reviewRow(title: "Size", value: petVM.petSize.capitalized)
                    
                    if !petVM.petDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notes:")
                                .font(.headline)
                            Text(petVM.petDescription)
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
}

extension Step5Review {
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
    
    private var petImageComponent: some View {
        ZStack {
            // Blue circle background
            Circle()
                .fill(Color(red: 0.37, green: 0.52, blue: 0.93).opacity(0.6))
                .frame(width: 120, height: 120)
            
            // Pet Image
            AsyncImage(url: URL(string: petVM.petImage?.url ?? "")) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                }
            }
        }
        .padding(.trailing, 24)
    }
}

#Preview {
    Step5Review()
    .withPetCorePreviewDependecies()
}
