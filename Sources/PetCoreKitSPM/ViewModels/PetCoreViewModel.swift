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
                return successResponse("Success", shouldSetAlert: false)
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
                return successResponse("Success", shouldSetAlert: false)
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
    
    private func successResponse(_ message: String = "Success", shouldSetAlert: Bool = true) -> ResponseModel<String> {
        if shouldSetAlert {
            setAlert(message: message, success: true)
        }
        return ResponseModel<String>(data: message, error: nil)
    }
    
    public func calculateAge(from dateString: String) -> String? {
        // First try ISO8601DateFormatter for the backend format (2022-08-02T00:00:00.000Z)
        let iso8601Formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Fallback to manual DateFormatter for other formats
        let inputFormatter: DateFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Simple date format fallback
        let simpleDateFormatter: DateFormatter = DateFormatter()
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        simpleDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var birthDate: Date?
        
        // Try parsing with ISO8601 first
        if let date: Date = iso8601Formatter.date(from: dateString) {
            birthDate = date
        }
        // Try parsing with manual DateFormatter
        else if let date: Date = inputFormatter.date(from: dateString) {
            birthDate = date
        }
        // Try simple date format as fallback
        else if let date: Date = simpleDateFormatter.date(from: dateString) {
            birthDate = date
        }
        
        guard let birthDate: Date = birthDate else { return nil }
        
        let calendar: Calendar = Calendar.current
        let now: Date = Date()
        let components: DateComponents = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        
        if let years: Int = components.year, let months: Int = components.month {
            if years > 0 {
                return years == 1 ? "1 year old" : "\(years) years old"
            } else if months > 0 {
                return months == 1 ? "1 month old" : "\(months) months old"
            } else {
                return "Less than 1 month old"
            }
        }
        
        return nil
    }
    
    public func formatDate(_ dateString: String) -> String {
        // First ISO8601DateFormatter for the backend format (2022-08-02T00:00:00.000Z)
        let iso8601Formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Fallback to manual DateFormatter for other formats
        let inputFormatter: DateFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Simple date format fallback
        let simpleDateFormatter: DateFormatter = DateFormatter()
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        simpleDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter: DateFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy"
        outputFormatter.locale = Locale.current
        
        // Try parsing with ISO8601 first
        if let date: Date = iso8601Formatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        // Try parsing with manual DateFormatter
        if let date: Date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        // Try simple date format as fallback
        if let date: Date = simpleDateFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        // If all parsing fails, return the original string
        return dateString
    }
}
