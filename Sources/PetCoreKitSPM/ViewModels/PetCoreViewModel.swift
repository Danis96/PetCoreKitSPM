//
//  PetCoreViewModel.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//
import Foundation
import Factory
import SQAUtility
import SwiftUICore
import Shared_kit


@MainActor
public class PetCoreViewModel: ObservableObject {
    
    @Injected(\PetCoreKitSPM.petCoreDataSource) var petCoreDataSource: PetCoreDataSourceProtocol
    @Injected(\SQAUtility.storageManager) var storageManager: StorageManager
    
    public init() {}
    
    @Published public var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSuccess: Bool = false
    
    @Published public var user: UserModel?
    @Published public var userPets: [PetModel] = []
    @Published public var selectedPet: PetModel?
    
    public func getUser() async -> ResponseModel<String> {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userID = storageManager.getUserID()
            let dataResponse = try await petCoreDataSource.fetchUserById(userID: userID ?? "")
            if let error = dataResponse.error {
                return failureResponse(error.description)
            } else {
                user = dataResponse.data
                return successResponse("Success")
            }
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }
    
    public func getUserPets() async -> ResponseModel<String> {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userID = storageManager.getUserID()
            let dataResponse = try await petCoreDataSource.fetchOwnerPets(ownerID: userID ?? "")
            if let error = dataResponse.error {
                return failureResponse(error.description)
            } else {
                userPets = dataResponse.data ?? []
                return successResponse("Success")
            }
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }
    
    public func setSelectedPet(_ pet: PetModel) {
        self.selectedPet = pet
    }
    
    private func setAlert(message: String, success: Bool) {
        self.alertMessage = message
        self.isSuccess = success
        self.showAlert = true
    }
    
    private func failureResponse(_ message: String) -> ResponseModel<String> {
        setAlert(message: message, success: false)
        return ResponseModel<String>(data: nil, error: message)
    }
    
    private func successResponse(_ message: String = "Success") -> ResponseModel<String> {
        setAlert(message: message, success: true)
        return ResponseModel<String>(data: message, error: nil)
    }
}
