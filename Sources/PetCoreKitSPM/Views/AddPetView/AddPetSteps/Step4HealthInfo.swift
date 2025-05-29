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
                    
                    Text("kg")
                        .foregroundColor(.gray)
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
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Birthday")
                    .font(.headline)
                
                DatePicker(
                    "Select Birthday",
                    selection: Binding<Date>(
                        get: { petVM.petBirthday },
                        set: { newValue in petVM.setPetBirthday(newValue) }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(colorHelper.getColor(.blue100))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Adoption Date")
                    .font(.headline)
                
                DatePicker(
                    "Select Adoption Date",
                    selection: Binding<Date>(
                        get: { petVM.petAdoptionDate },
                        set: { newValue in petVM.setPetAdoptionDate(newValue) }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(colorHelper.getColor(.blue100))
                .cornerRadius(8)
            }
            
            Spacer()
        }
    }
}

#Preview {
    Step4HealthInfo()
        .withPetCorePreviewDependecies()
}
