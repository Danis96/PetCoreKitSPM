//
//  Step4Review.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI

struct Step4HealthInfo: View {
    @Binding var petWeight: Double
    @Binding var petDescription: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Health information")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Weight (kg)")
                    .font(.headline)
                
                HStack {
                    TextField("0.0", value: $petWeight, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    Text("kg")
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Additional Notes")
                    .font(.headline)
                
                TextEditor(text: $petDescription)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
    }
}

#Preview {
    Step4HealthInfo(
        petWeight: .constant(5.5),
        petDescription: .constant("Sample description")
    )
}
