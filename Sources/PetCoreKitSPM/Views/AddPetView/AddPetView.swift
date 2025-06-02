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
    @EnvironmentObject private var petCoordinator: PetCoreCoordinator
    @EnvironmentObject private var breedVM: BreedKitViewModel
    @EnvironmentObject private var imageVM: ImageKitViewModel
    
    var body: some View {
         VStack(spacing: 0) {
                stepperHeader
                
                ScrollView {
                    VStack(spacing: 20) {
                        stepContent
                    }
                    .padding()
                }
                navigationButtons
        }
         .dismissKeyboardOnTap()
         .toolbar(content: {
             ToolbarItem(placement: .principal) {
                 Text("Add New Pet")
             }
         })
        .alert(isPresented: $petVM.showAlert) {
            Alert(
                title: Text(petVM.isSuccess ? "Success" : "Validation Error"),
                message: Text(petVM.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            Task {
                try await petVM.fetchPetType()
            }
        }
    }
}


extension AddPetView {
    // MARK: - Stepper Header
    private var stepperHeader: some View {
        VStack(spacing: 16) {
            // Progress Bar
            HStack(spacing: 8) {
                ForEach(0..<petVM.totalSteps, id: \.self) { step in
                    Rectangle()
                        .fill(step <= petVM.currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.3), value: petVM.currentStep)
                }
            }
            .padding(.horizontal)
            
            // Step Indicators
            HStack {
                ForEach(0..<petVM.totalSteps, id: \.self) { step in
                    VStack(spacing: 8) {
                        Circle()
                            .fill(step <= petVM.currentStep ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text("\(step + 1)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(step <= petVM.currentStep ? .white : .gray)
                            )
                        
                        Text(petVM.stepTitles[step])
                            .font(.caption2)
                            .foregroundColor(step <= petVM.currentStep ? .blue : .gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    if step < petVM.totalSteps - 1 {
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
        switch petVM.currentStep {
            case 0:
                Step1BasicInfo()
            case 1:
                Step2PetBreed()
            case 2:
                Step3PetDetails()
            case 3:
                Step4HealthInfo()
            case 4:
                Step5Review()
            default:
                EmptyView()
        }
    }
    
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack {
            if petVM.currentStep > 0 {
                SQAButton(title: "Previous", style: .outline) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        petVM.currentStep -= 1
                    }
                }
            }
            
            Spacer()
            
            if petVM.currentStep < petVM.totalSteps - 1 {
                SQAButton(title: "Next", style: .primary, size: .medium) {
                    if petVM.validateCurrentStepAndShowAlert() {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if petVM.currentStep == 0 {
                                Task {
                                    await fetchBreedData()
                                }
                            }
                            if petVM.currentStep == 2 {
                                Task {
                                   try await uploadPetPicture()
                                }
                            }
                            withAnimation(.easeInOut(duration: 0.3)) {
                                petVM.currentStep += 1
                            }
                        }
                    }
                }
            } else {
                SQAButton(title: "Save Pet") {
                    Task {
                       await savePet()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
}

extension AddPetView {
    // MARK: - Actions
    private func savePet() async {
       let response = try await petVM.createPet()
        if response.isSuccess {
            petCoordinator.navigate(to: .dashboard)
            petVM.resetCurrentStep()
        }
    }
    
    private func fetchBreedData() async {
       let breedResponse = await breedVM.fetchBreeds(petSpecie: petVM.petType)
        if breedResponse.isSuccess && !breedResponse.data!.isEmpty {
            petVM.breeds = breedResponse.data ?? []
        }
    }

    private func uploadPetPicture() async {
        let response = await imageVM.uploadImage(folder: .petProfile)
        if response.isSuccess  {
            petVM.setPetImage(response.data)
        }
    }
}




#Preview {
    AddPetView()
        .withPetCorePreviewDependecies()
        .withSharedKitPreviewDependecies()
}

