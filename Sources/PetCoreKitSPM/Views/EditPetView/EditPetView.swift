//
//  EditPetView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 5. 6. 2025..
//
import SwiftUI

struct EditPetView: View {
    
    @EnvironmentObject var petVM: PetCoreViewModel
//    @EnvironmentObject var petCoordinator: PetCoreCoordinator
    
    var body: some View {
        LazyVStack {
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit \(petVM.editPetModel?.name ?? "Unknown")")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .onAppear {
            Task {
                await getInitialData()
            }
        }
    }
}


extension EditPetView {
    private func getInitialData() async {
        do {
            try await petVM.fetchPetByID()
        } catch {
            print(error.localizedDescription)
        }
       
    }
}

#Preview {
    NavigationStack {
        EditPetView()
//            .withSharedKitPreviewDependecies()
            .environmentObject(PetCoreViewModel())
    }
}
