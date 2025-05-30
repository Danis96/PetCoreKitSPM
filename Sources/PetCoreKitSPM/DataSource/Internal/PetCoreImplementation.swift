//
//  PetCoreImplementation.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//
import Shared_kit
import Foundation
import SQAUtility
import SQAServices
import Factory

public final class PetCoreDataSourceImplementation: PetCoreDataSourceProtocol, @unchecked Sendable {
    
    public static let shared: PetCoreDataSourceProtocol = PetCoreDataSourceImplementation()
    
    public init() {}
    
    @Injected(\SQAServices.networkManager) var networkService: NetworkServiceManager
    @Injected(\SQAServices.apiHeaderHelper) var headerHelper: ApiHeaders
    @Injected(\SQAUtility.storageManager) var storageManager: StorageManager
    
    public func fetchUserById(userID: String) async throws -> ResponseModel<UserModel> {
        do {
           
            let response = try await networkService.get(
                path: PetCoreAPIPaths.shared.path(for: .getUserByID, concatValue: userID),
                headers: headerHelper.getValue(type: .auth_app_json, accessToken: getAuthToken() ?? ""),
                as: UserModel.self
            )
            
            return ResponseModel(data: response, error: nil)
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    public func addPet(pet: PetModel) async throws -> ResponseModel<PetModel> {
        do {
            
            let jsonData = try JSONEncoder().encode(pet)
            
            let response = try await networkService.post(
                path: PetCoreAPIPaths.shared.path(for: .createPet),
                body: jsonData,
                headers: headerHelper.getValue(type: .auth_app_json, accessToken: getAuthToken() ?? ""),
                as: PetModel.self
            )
            
            return ResponseModel(data: response, error: nil)
            
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    public func fetchOwnerPets(ownerID: String) async throws -> ResponseModel<[PetModel]> {
        do {
            
            let response = try await networkService.get(
                path: PetCoreAPIPaths.shared.path(for: .getOwnersPets, concatValue: ownerID),
                headers: headerHelper.getValue(type: .auth_app_json, accessToken: getAuthToken() ?? ""),
                as: [PetModel].self
            )
            
            return ResponseModel(data: response, error: nil)
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    public func fetchPetById(petID: String) async throws -> ResponseModel<PetModel> {
        do {
            
            let response = try await networkService.get(
                path: PetCoreAPIPaths.shared.path(for: .getPetByID, concatValue: petID),
                headers: headerHelper.getValue(type: .auth_app_json, accessToken: getAuthToken() ?? ""),
                as: PetModel.self
            )
            
            return ResponseModel(data: response, error: nil)
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    public func editPet(pet: PetModel) async throws -> ResponseModel<PetModel> {
        do {
            
            let jsonData = try JSONEncoder().encode(pet)
            
            let response = try await networkService.put(
                path: PetCoreAPIPaths.shared.path(for: .editPet, concatValue: pet.id ?? ""),
                body: jsonData,
                headers: headerHelper.getValue(type: .auth_app_json, accessToken: getAuthToken() ?? ""),
                as: PetModel.self
            )
            
            return ResponseModel(data: response, error: nil)
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    public func deletePet(petID: String) async throws -> ResponseModel<String> {
        do {
            
            _ = try await networkService.delete(
                path: PetCoreAPIPaths.shared.path(for: .deletePet, concatValue: petID),
                as: EmptyResponse.self
            )
            
            return ResponseModel(data: "Success", error: nil)
            
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    public func fetchPetType() async throws -> ResponseModel<[PetTypeModel]> {
        do {
            let response = try await networkService.get(
                path: PetCoreAPIPaths.shared.path(for: .getPetType),
                headers: headerHelper.getValue(type: .auth_app_json, accessToken: getAuthToken() ?? ""),
                as: [PetTypeModel].self,
            )
            
            return ResponseModel(data: response, error: nil)
        } catch {
            return ResponseModel(data: nil, error: error.localizedDescription)
        }
    }
    
    private func getAuthToken() -> String? {
        do {
            let token = try storageManager.getSecureValue(forKey: .accessToken)
            return token
        } catch {
            return nil
        }
    }
}
