//
//  PetCoreAPIPaths.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//

public enum PetCoreRoute: String, Identifiable {
    case createPet
    case editPet
    case deletePet
    case getPetByID
    case getOwnersPets
    case getUserByID
    case getPetType
    
    public var id: String { rawValue }
}


public enum PetCoreViewRoute: String, Identifiable {
    case dashboard
    case createPet
    case updatePet
    case petProfile
    
    public var id: String { rawValue }
}

public final class PetCoreAPIPaths: @unchecked Sendable {
    public static let shared: PetCoreAPIPaths = PetCoreAPIPaths()
    private init() {}
    
    public func path(for endpoint: PetCoreRoute, concatValue: String? = nil,  secondConcatValue: String? = nil,  thirdConcatValue: String? = nil) -> String {
        switch endpoint {
            case .createPet:
                return "/pets"
            case .editPet:
                return "/pets/\(concatValue ?? "")"
            case .deletePet:
                return "/pets/\(concatValue ?? "")"
            case .getPetByID:
                return "/pets/\(concatValue ?? "")"
            case .getOwnersPets:
                return "/pets/owner/\(concatValue ?? "")"
            case .getUserByID:
                return "/user/\(concatValue ?? "")"
            case .getPetType:
                return "/pets/animals/types"
        }
    }
}
