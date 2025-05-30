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
            Text("Health information")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Weight (kg)")
                    .font(.headline)
                
                HStack {
                    SQATextField(placeholder: "Enter weight", text: $petVM.petWeight, keyboardType: .number)
                    Text("kg").foregroundColor(.gray)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Size")
                    .font(.headline)
                
                Picker("Select Size", selection: Binding<String>(
                    get: { petVM.petSize },
                    set: { newValue in petVM.setPetSize(newValue) }
                )) {
                    ForEach(petVM.sizes, id: \.self) { size in
                        Text(size.capitalized)
                            .tag(size)
                    }
                }
                .pickerStyle(PalettePickerStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            // MARK: - Gender Picker Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Gender")
                    .font(.headline)
                
                Picker("Select Gender", selection: Binding<String>(
                    get: { petVM.petGender },
                    set: { newValue in petVM.setPetGender(newValue) }
                )) {
                    ForEach(petVM.genders, id: \.self) { gender in
                        Text(gender.capitalized)
                            .tag(gender)
                    }
                }
                .pickerStyle(PalettePickerStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Birthday")
                    .font(.headline)
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    DatePicker(
                        "",
                        selection: Binding<Date>(
                            get: { petVM.petBirthday },
                            set: { newValue in petVM.setPetBirthday(newValue) }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                   
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            
            // Same as birthday button
            if petVM.shouldShowSameAsBirthdayButton {
                HStack {
                    Spacer()
                    
                    SQAButton(title: "Same as birthday", icon: "arrow.down.circle.fill", style: .outline, size: .small) {
                        petVM.setAdoptionDateSameAsBirthday()
                    }
                    .frame(width: 200)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Adoption Date")
                    .font(.headline)
                
                HStack {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "house")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    DatePicker(
                        "",
                        selection: Binding<Date>(
                            get: { petVM.petAdoptionDate },
                            set: { newValue in petVM.setPetAdoptionDate(newValue) }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
    }
}

#Preview {
    Step4HealthInfo()
        .withPetCorePreviewDependecies()
}
