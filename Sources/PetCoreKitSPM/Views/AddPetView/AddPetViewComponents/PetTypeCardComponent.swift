//
//  PetTypeCard.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 28. 5. 2025..
//

import SwiftUI

struct PetTypeCardComponent: View {
    let petType: PetTypeModel
    let isSelected: Bool
    let onTap: () -> Void
    
    private var displayName: String {
        let typeName: String = petType.type ?? ""
        return typeName.replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Pet Type Image Container
                ZStack {
                    Circle()
                        .fill(
                            isSelected ? 
                            LinearGradient(
                                colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    AsyncImage(url: URL(string: petType.image ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56, height: 56)
                            .foregroundColor(isSelected ? .blue : .gray)
                    } placeholder: {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 56, weight: .medium))
                            .foregroundColor(isSelected ? .blue : .gray)
                    }
                }
                .scaleEffect(isSelected ? 1.1 : 1.0)
                
                // Pet Type Name
                Text(displayName)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 100, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ?
                        Color.blue.opacity(0.05) :
                        Color.clear
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.blue.opacity(0.3) : Color.clear,
                                lineWidth: 1.5
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Pet Type Card Preview
struct PetTypeCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                ForEach(PetCoreDeveloperPreview.shared.previewAnimalType.prefix(4), id: \.self) { petType in
                    PetTypeCardComponent(
                        petType: petType,
                        isSelected: PetCoreDeveloperPreview.shared.petCoreViewModel.petType == petType.type ?? "",
                        onTap: {
                            PetCoreDeveloperPreview.shared.petCoreViewModel.setPetType(petType.type?.uppercased() ?? "")
                        }
                    )
                }
            }
            
            // Show selected and unselected states
            HStack(spacing: 20) {
                PetTypeCardComponent(
                    petType: PetCoreDeveloperPreview.shared.previewAnimalType.first ?? PetTypeModel(),
                    isSelected: false,
                    onTap: {}
                )
                
                PetTypeCardComponent(
                    petType: PetCoreDeveloperPreview.shared.previewAnimalType.first ?? PetTypeModel(),
                    isSelected: true,
                    onTap: {}
                )
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
