//
//  PetCoreProtocols.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//

import Foundation
import Shared_kit
import SwiftUI

public protocol PetCoreDataSourceProtocol: Sendable {
    func addPet(pet: PetModel) async throws -> ResponseModel<PetModel>
    func fetchOwnerPets(ownerID: String) async throws -> ResponseModel<[PetModel]>
    func fetchPetById(petID: String) async throws -> ResponseModel<PetModel>
    func fetchUserById(userID: String) async throws -> ResponseModel<UserModel>
    func editPet(pet: PetModel) async throws -> ResponseModel<PetModel>
    func deletePet(petID: String) async throws -> ResponseModel<String>
}
