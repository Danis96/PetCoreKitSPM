//
//  PetProfileView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 22. 5. 2025..
//
import SwiftUI
import Factory
import Shared_kit
import SQAUtility

struct PetProfileView: View {
    
    @EnvironmentObject var petVM: PetCoreViewModel
    @EnvironmentObject var breedVM: BreedKitViewModel
    @Injected(\SQAUtility.colorHelper) var colorHelper: ColorHelper
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                petProfileHeader
                
                petAppearanceSection
                
                petInformationSection
                
                petImportantDatesSection
                
                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
           bottomButton
                .background(.ultraThinMaterial)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Pet Profile")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("") {
                    print("Open delete dialog")
                }
                .background(Image(systemName: "trash.fill").resizable().scaledToFit() .frame(width: 20, height: 20).foregroundColor(.red))
                    .padding(.trailing, 10)
            }
        }
        .onAppear {
            Task {
                try await getInitialData()
            }
        }
    }
}

// MARK: - Profile Header Section
extension PetProfileView {
    private var petProfileHeader: some View {
        VStack(spacing: 16) {
            petImageWithEditButton
            petNameAndBreedInfo
        }
        .padding(.vertical, 30)
    }
    
    private var petImageWithEditButton: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 120, height: 120)
            
            AsyncImage(url: URL(string: petVM.selectedPet?.image?.url ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                case .failure(_), .empty:
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                          print("Open image picker from shared")
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.7)))
                    }
                }
                Spacer()
            }
            .frame(width: 100, height: 100)
        }
    }
    
    private var petNameAndBreedInfo: some View {
        VStack(spacing: 8) {
            HStack {
                Text(petVM.selectedPet?.name ?? "Unknown Pet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Shared_kit.startCustomBreedKit(
                    width: 30,
                    height: 30,
                    icon: "teddybear"
                ) {}
            }
            
            Text("\(petVM.selectedPet?.petType?.capitalized ?? "Pet") | \(breedVM.selectedBreed?.name ?? petVM.selectedPet?.breedName ?? "Unknown Breed")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Appearance Section
extension PetProfileView {
    private var petAppearanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Appearance and distinctive signs")
            
            Text(petVM.selectedPet?.description ?? "No distinctive signs recorded.")
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 20)
    }
}

// MARK: - Information Section
extension PetProfileView {
    private var petInformationSection: some View {
        VStack(spacing: 12) {
            informationRow(label: "Gender", value: petVM.selectedPet?.gender?.capitalized ?? "Unknown")
            informationRow(label: "Size", value: petVM.selectedPet?.size?.capitalized ?? "Unknown")
            informationRow(label: "Weight", value: formatWeight())
        }
        .padding(.bottom, 20)
    }
    
    private func informationRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatWeight() -> String {
        if let weight: Double = petVM.selectedPet?.weight, weight > 0 {
            return String(format: "%.1f kg", weight)
        } else if let weightValue: String = petVM.selectedPet?.weightValue, !weightValue.isEmpty {
            return "\(weightValue) kg"
        }
        return "Unknown"
    }
}

// MARK: - Important Dates Section
extension PetProfileView {
    private var petImportantDatesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Important Dates")
            
            VStack(spacing: 16) {
                if let dateOfBirth: String = petVM.selectedPet?.dateOfBirth, !dateOfBirth.isEmpty {
                    importantDateRow(
                        icon: "calendar",
                        title: "Birthday",
                        date: dateOfBirth,
                        age: petVM.calculateAge(from: dateOfBirth)
                    )
                }
                
                if let adoptionDate: String = petVM.selectedPet?.adoptionDate, !adoptionDate.isEmpty {
                    importantDateRow(
                        icon: "house",
                        title: "Adoption Day",
                        date: adoptionDate,
                        age: nil
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func importantDateRow(icon: String, title: String, date: String, age: String?) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(petVM.formatDate(date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let age: String = age {
                Text(age)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
    }
}


// MARK: - Buttons
extension PetProfileView {
    private var bottomButton: some View {
            SQAButton(title: "Edit \(petVM.selectedPet?.name ?? "pet")") {
                print(">>> Edit Pet")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
    }
}

// MARK: - Helper Views
extension PetProfileView {
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Data Loading
extension PetProfileView {
    private func getInitialData() async throws {
        let response = try await breedVM.fetchBreeds(petSpecie: petVM.selectedPet?.petType ?? "")
        if response.isSuccess {
            breedVM.selectBreed(breedID: petVM.selectedPet?.breedID ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        PetProfileView()
            .withBreedKitPreviewDependecies()
            .environmentObject(PetCoreViewModel())
    }
}
