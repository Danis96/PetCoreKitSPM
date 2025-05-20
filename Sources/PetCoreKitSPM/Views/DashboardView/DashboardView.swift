//
//  DashboardView.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//
import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: PetCoreViewModel
    
     var body: some View {
         
        Text("Dashboard")
             .onAppear {
                 Task {
                     await fetchData()
                 }
             }
    }
}

extension DashboardView {
    
    private func fetchData() async {
        let response = await viewModel.getUser()
    }
    
}

#Preview {
    DashboardView()
        .environmentObject(PetCoreViewModel())
}

