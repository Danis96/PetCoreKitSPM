//
//  Step4Review.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI
import SQAUtility
import Factory

struct Step4HealthInfo: View {
    
    @EnvironmentObject var petVM: PetCoreViewModel
    @Injected(\SQAUtility.colorHelper) var colorHelper: ColorHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerTitle
            weightSection
            sizeSection
            genderSection
            birthdaySection
            sameAsBirthdayButton
            adoptionDateSection
            Spacer()
        }
    }
}

// MARK: - UI Components
private extension Step4HealthInfo {
    
    var headerTitle: some View {
        Text(PetCoreKitSPMStrings.petCoreAddS4HealthInfoTitle)
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    var weightSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(PetCoreKitSPMStrings.petCoreAddS4WeightLabel)
            
            HStack {
                SQATextField(
                    placeholder: PetCoreKitSPMStrings.petCoreAddS4WeightPlaceholder,
                    text: $petVM.petWeight,
                    keyboardType: .number
                )
                Text(PetCoreKitSPMStrings.petCoreAddS4WeightUnit).foregroundColor(.gray)
            }
        }
    }
    
    var sizeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(PetCoreKitSPMStrings.petCoreAddS4SizeLabel)
            
            createPicker(
                title: PetCoreKitSPMStrings.petCoreAddS4SizePickerTitle,
                selection: Binding<String>(
                    get: { petVM.petSize },
                    set: { newValue in petVM.setPetSize(newValue) }
                ),
                options: petVM.sizes
            )
        }
    }
    
    var genderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(PetCoreKitSPMStrings.petCoreAddS4GenderLabel)
            
            createPicker(
                title: PetCoreKitSPMStrings.petCoreAddS4GenderPickerTitle,
                selection: Binding<String>(
                    get: { petVM.petGender },
                    set: { newValue in petVM.setPetGender(newValue) }
                ),
                options: petVM.genders
            )
        }
    }
    
    var birthdaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(PetCoreKitSPMStrings.petCoreAddS4BirthdayLabel)
            
            createDatePicker(
                icon: "calendar",
                selection: Binding<Date>(
                    get: { petVM.petBirthday },
                    set: { newValue in petVM.setPetBirthday(newValue) }
                )
            )
        }
    }
    
    var sameAsBirthdayButton: some View {
        Group {
            if petVM.shouldShowSameAsBirthdayButton {
                HStack {
                    Spacer()
                    
                    SQAButton(
                        title: PetCoreKitSPMStrings.petCoreAddS4SameAsBirthdayButton,
                        icon: "arrow.down.circle.fill",
                        style: .outline,
                        size: .small
                    ) {
                        petVM.setAdoptionDateSameAsBirthday()
                    }
                    .frame(width: 200)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    var adoptionDateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(PetCoreKitSPMStrings.petCoreAddS4AdoptionDateLabel)
            
            createDatePicker(
                icon: "house",
                selection: Binding<Date>(
                    get: { petVM.petAdoptionDate },
                    set: { newValue in petVM.setPetAdoptionDate(newValue) }
                )
            )
        }
    }
}

// MARK: - Helper Methods
private extension Step4HealthInfo {
    
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
    }
    
    func createPicker(
        title: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        Picker(title, selection: selection) {
            ForEach(options, id: \.self) { option in
                Text(option.capitalized)
                    .tag(option)
            }
        }
        .pickerStyle(PalettePickerStyle())
        .pickerBackground()
    }
    
    func createDatePicker(
        icon: String,
        selection: Binding<Date>
    ) -> some View {
        HStack {
            createIconBackground(icon: icon)
            
            DatePicker(
                "",
                selection: selection,
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
    
    func createIconBackground(icon: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.8))
                .frame(width: 40, height: 40)
            
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

// MARK: - View Modifiers
private extension View {
    
    func pickerBackground() -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

#Preview {
    Step4HealthInfo()
        .withPetCorePreviewDependecies()
}
