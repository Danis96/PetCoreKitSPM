//
//  AddPetView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 27. 5. 2025..
//

import SwiftUI
import SQAUtility
import Shared_kit 

struct AddPetView: View {
    
    @EnvironmentObject private var petVM: PetCoreViewModel
    
    @State private var currentStep: Int = 0
    
    @State private var petAge: Int = 0
    @State private var petWeight: Double = 0.0
    @State private var petDescription: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker: Bool = false
    
    private let totalSteps: Int = 5
    private let stepTitles: [String] = [
        "Basic Info",
        "Breed",
        "Pet Details",
        "Health Info",
        "Review"
    ]
    
    var body: some View {
         VStack(spacing: 0) {
                // Stepper Header
                stepperHeader
                
                // Content Area
                ScrollView {
                    VStack(spacing: 20) {
                        stepContent
                    }
                    .padding()
                }
                
                // Navigation Buttons
                navigationButtons
        }
         .toolbar(content: {
             ToolbarItem(placement: .principal) {
                 Text("Add New Pet")
             }
         })
        .onAppear {
            Task {
                try await petVM.fetchPetType()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    // MARK: - Stepper Header
    private var stepperHeader: some View {
        VStack(spacing: 16) {
            // Progress Bar
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    Rectangle()
                        .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .padding(.horizontal)
            
            // Step Indicators
            HStack {
                ForEach(0..<totalSteps, id: \.self) { step in
                    VStack(spacing: 8) {
                        Circle()
                            .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text("\(step + 1)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(step <= currentStep ? .white : .gray)
                            )
                        
                        Text(stepTitles[step])
                            .font(.caption2)
                            .foregroundColor(step <= currentStep ? .blue : .gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    if step < totalSteps - 1 {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Step Content
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            Step1BasicInfo()
        case 1:
            Step2PetBreed()
        case 2:
            Step3PetDetails(
                petAge: $petAge,
                selectedImage: $selectedImage,
                showingImagePicker: $showingImagePicker
            )
        case 3:
            Step4HealthInfo(
                petWeight: $petWeight,
                petDescription: $petDescription
            )
        case 4:
            Step5Review(
                petAge: petAge,
                petWeight: petWeight,
                petDescription: petDescription,
                selectedImage: selectedImage
            )
        default:
            EmptyView()
        }
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                SQAButton(title: "Previous", style: .outline) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                }
            }
            
            Spacer()
            
            if currentStep < totalSteps - 1 {
                SQAButton(title: "Next", style: .primary, size: .medium) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if currentStep == 0 {
                            Task {
                                await fetchBreedData()
                            }
                        }
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep += 1
                        }
                    }
                }.disabled(!canProceedToNextStep)
               
            } else {
                SQAButton(title: "Save Pet") {
                    savePet()
                }
                .disabled(!isFormComplete)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
    
    // MARK: - Helper Properties
    private var canProceedToNextStep: Bool {
        switch currentStep {
        case 0:
            return !(petVM.petName.isEmpty ?? true) && !petVM.petType.isEmpty
        case 1:
            return !petVM.petBreed.isEmpty
        case 2:
            return petWeight > 0
        default:
            return true
        }
    }
    
    private var isFormComplete: Bool {
        return !(petVM.petName.isEmpty ?? true) && !petVM.petType.isEmpty && !petVM.petBreed.isEmpty && petWeight > 0
    }
    
    // MARK: - Actions
    private func savePet() {
        // Implement your save logic here
        print("Saving pet: \(petVM.petName ?? "")")
        // You can add navigation back or show success message
    }
    
    private func fetchBreedData() async {
        await petVM.fetchBreeds()
    }
}



#Preview {
    AddPetView()
        .withPetCorePreviewDependecies()
}

