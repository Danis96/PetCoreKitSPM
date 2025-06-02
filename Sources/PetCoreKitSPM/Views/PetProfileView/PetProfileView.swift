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
    @EnvironmentObject var petCoordinator: PetCoreCoordinator
    @EnvironmentObject var breedVM: BreedKitViewModel
    @EnvironmentObject var imageVM: ImageKitViewModel
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
                    petVM.setShowDeleteDialog(true)
                }
                .background(Image(systemName: "trash.fill").resizable().scaledToFit() .frame(width: 20, height: 20).foregroundColor(.red))
                .padding(.trailing, 10)
            }
        }
        .alert(isPresented: $petVM.showAlert) {
            Alert(
                title: Text(petVM.isSuccess ? "Success" : "Error"),
                message: Text(petVM.alertMessage),
                dismissButton: .default(Text("Ok")) { petVM.showAlert = false }
            )
        }
        .alert("Delete Pet", isPresented: $petVM.showDeleteDialog) {
            Button("Cancel", role: .cancel) {
                petVM.setShowDeleteDialog(false)
            }
            Button("Delete", role: .destructive) {
                Task {
                    try await deletePet()
                }
            }
        } message: {
            Text("Are you sure you want to delete \(petVM.selectedPet?.name ?? "this pet")? This action cannot be undone.")
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
        ImageKitCoordinator.shared.start(
            selectedImage: $petVM.petImage,
            placeholderText: "Edit pet image",
            type: .userProfile,
            typeID: petVM.user?.id ?? "",
            allowInternalUse: false,
        )
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
                    icon: "pawprint.circle"
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
        SQAButton(title: petVM.hasNewImageSelected ? "Save Image" : "Edit \(petVM.selectedPet?.name ?? "pet")") {
            if petVM.hasNewImageSelected {
                Task {
                   let imageResponse = try await uploadPetPicture()
                   if imageResponse.isSuccess {
                       try await changePetImage()
                    } else {
                        
                    }
                }
            } else {
                print(">>> Edit Pet")
                // Handle editing pet here
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .onChange(of: petVM.petImage) { _, _ in
            petVM.checkForNewImageSelection()
        }
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
    
    private func uploadPetPicture() async -> ResponseModel<String> {
        let response = await imageVM.uploadImage(folder: .petProfile)
        if response.isSuccess  {
            petVM.setPetImage(response.data)
            return ResponseModel<String>(data: "Success", error: nil)
        } else {
            return ResponseModel<String>(data: nil, error: "Error")
        }
    }
    
    private func changePetImage() async throws {
        let response = try await petVM.savePetImage()
    }
    
    private func deletePet() async throws {
        let response = try await petVM.deletePet()
        if response.isSuccess {
            petCoordinator.popToRoot()
        }
    }
}

#Preview {
    NavigationStack {
        PetProfileView()
            .withSharedKitPreviewDependecies()
            .environmentObject(PetCoreViewModel())
    }
}
