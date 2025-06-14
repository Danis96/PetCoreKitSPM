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
    @Injected(\Shared_kit.breedDataSource) var breedDataSource: BreedKitDataSourceProtocols
    @Injected(\SQAUtility.storageManager) var storageManager: StorageManager
    
    public init() {}
    
    @Published public var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published public var showDeleteDialog: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSuccess: Bool = false
    
    @Published public var user: UserModel?
    @Published public var userPets: [PetModel] = []
    @Published public var selectedPet: PetModel?
    @Published public var petImage: ImageModel?
    @Published public var petTypeList: [PetTypeModel] = []
    @Published public var breeds: [BreedModel] = []
    @Published public var selectedBreed: BreedModel? = nil
    
    @Published public var hasNewImageSelected: Bool = false
    private var originalPetImage: ImageModel?
    
    
    @Published public var currentStep: Int = 0
    public let totalSteps: Int = 5
    public let stepTitles: [String] = [
        PetCoreKitSPMStrings.petCoreVM_stepTitle_basicInfo,
        PetCoreKitSPMStrings.petCoreVM_stepTitle_breed,
        PetCoreKitSPMStrings.petCoreVM_stepTitle_petDetails,
        PetCoreKitSPMStrings.petCoreVM_stepTitle_healthInfo,
        PetCoreKitSPMStrings.petCoreVM_stepTitle_review
    ]
    
    // MARK: - Add pet properties
    @Published public var petName: String = ""
    @Published public var petType: String = ""
    @Published public var petBreed: String = ""
    @Published public var petBreedID: String = ""
    @Published public var petWeight: String = ""
    @Published public var petDescription: String = ""
    @Published public var petGender: String = PetCoreKitSPMStrings.petCoreVM_defaultGender
    public let genders: [String] = [PetCoreKitSPMStrings.petCoreVM_gender_male, PetCoreKitSPMStrings.petCoreVM_gender_female, PetCoreKitSPMStrings.petCoreVM_gender_intersex]
    @Published public var petSize: String = PetCoreKitSPMStrings.petCoreVM_defaultSize
    public let sizes: [String] = [PetCoreKitSPMStrings.petCoreVM_size_small, PetCoreKitSPMStrings.petCoreVM_size_medium, PetCoreKitSPMStrings.petCoreVM_size_large]
    
    @Published public var petBirthday: Date = Date()
    @Published public var petAdoptionDate: Date = Date()
    private var petBirthdayStringForAPI: String = ""
    private var petAdoptionDateStringForAPI: String = ""
    // Date validation error properties
    @Published public var birthdayValidationError: String? = nil
    @Published public var adoptionDateValidationError: String? = nil
    
    // MARK: - Edit pet properties
    @Published public var editPetModel: PetModel?
    @Published public var editPetName: String = ""
    @Published public var editPetType: String = ""
    @Published public var editPetBreed: String = ""
    @Published public var editPetBreedID: String = ""
    @Published public var editPetWeight: String = ""
    @Published public var editPetDescription: String = ""
    @Published public var editPetGender: String = PetCoreKitSPMStrings.petCoreVM_defaultGender
    public let editGenders: [String] = [PetCoreKitSPMStrings.petCoreVM_gender_male, PetCoreKitSPMStrings.petCoreVM_gender_female, PetCoreKitSPMStrings.petCoreVM_gender_intersex]
    @Published public var editPetSize: String = PetCoreKitSPMStrings.petCoreVM_defaultSize
    public let editSizes: [String] = [PetCoreKitSPMStrings.petCoreVM_size_small, PetCoreKitSPMStrings.petCoreVM_size_medium, PetCoreKitSPMStrings.petCoreVM_size_large]
    @Published public var editPetBirthday: Date = Date()
    @Published public var editPetAdoptionDate: Date = Date()
    private var editPetBirthdayStringForAPI: String = ""
    private var editPetAdoptionDateStringForAPI: String = ""
    // Date validation error properties
    @Published public var editBirthdayValidationError: String? = nil
    @Published public var editAdoptionDateValidationError: String? = nil
    
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
    
    public func checkForNewImageSelection() {
        let isNewImage: Bool = {
            if originalPetImage == nil && petImage == nil {
                return false
            }
            
            if (originalPetImage == nil) != (petImage == nil) {
                return true
            }
            
            if let original = originalPetImage, let current = petImage {
                if current.imageProcessed != nil && current.url == nil && current.imageId == nil {
                    return true
                }
                
                return original.imageId != current.imageId || original.url != current.url
            }
            
            return false
        }()
        
        hasNewImageSelected = isNewImage
    }
    
    
    public func savePetImage() async -> ResponseModel<String> {
        do {
            let pet = copyPetModelAndChangeImage()
            let dataResponse = try await petCoreDataSource.editPet(pet: pet)
            if let error = dataResponse.error {
                return failureResponse(error.description)
            } else {
                selectedPet = dataResponse.data
                return successResponse("Success", shouldSetAlert: true)
            }
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }
    
    private func copyPetModelAndChangeImage() -> PetModel {
        guard let pet: PetModel = selectedPet else {
            fatalError(PetCoreKitSPMStrings.petCoreVM_errorSelectedPetNil)
        }
        var changedPetModel: PetModel = pet
        changedPetModel.image = petImage
        return changedPetModel
    }
    
    public func fetchPetType() async throws -> ResponseModel<String> {
        do {
            let dataResponse = try await petCoreDataSource.fetchPetType()
            petTypeList = dataResponse.data ?? []
            
            return successResponse("Success", shouldSetAlert: false)
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }
    
    public func fetchPetByID() async throws -> ResponseModel<String> {
        do {
            let dataResponse = try await petCoreDataSource.fetchPetById(petID: selectedPet?.id ?? "")
            editPetModel = dataResponse.data ?? PetModel()
            return successResponse("Success", shouldSetAlert: false)
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }
    
    public func createPet() async -> ResponseModel<String> {
        do {
          let pet = addAndReturnPetForCreation()
          let response = try await petCoreDataSource.addPet(pet: pet)
          return ResponseModel<String>(data: "Success", error: nil)
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }

    public func deletePet() async -> ResponseModel<String> {
        do {
            guard let petID: String = selectedPet?.id else {
                fatalError(PetCoreKitSPMStrings.petCoreVM_errorSelectedPetIdNil)
            }
          let response = try await petCoreDataSource.deletePet(petID: petID)
          return successResponse(PetCoreKitSPMStrings.petCoreVM_successDeletionMessage)
        } catch let error as NSError {
            return failureResponse(error.description)
        }
    }

    public var canProceedToNextStep: Bool {
        switch currentStep {
            case 0:
                return !(petName.isEmpty ?? true) && !petType.isEmpty
            case 1:
                return !petBreed.isEmpty
            case 2:
                return !petDescription.isEmpty
            case 3:
                return !petWeight.isEmpty && !petSize.isEmpty
            default:
                return true
        }
    }
    
    private func failureResponse(_ message: String) -> ResponseModel<String> {
        setAlert(message: message, success: false)
        return ResponseModel<String>(data: nil, error: message)
    }
    
    private func successResponse(_ message: String = PetCoreKitSPMStrings.petCoreVM_successMessage, shouldSetAlert: Bool = true) -> ResponseModel<String> {
        if shouldSetAlert {
            setAlert(message: message, success: true)
        }
        return ResponseModel<String>(data: message, error: nil)
    }
    
    public func validateCurrentStepAndShowAlert() -> Bool {
        switch currentStep {
        case 0:
            if petName.isEmpty {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationPetNameRequired, success: false)
                return false
            }
            if petType.isEmpty {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationPetTypeRequired, success: false)
                return false
            }
        case 1:
            if petBreed.isEmpty {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationPetBreedRequired, success: false)
                return false
            }
        case 2:
            if petDescription.isEmpty {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationPetDescriptionRequired, success: false)
                return false
            }
        case 3:
            if petWeight.isEmpty {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationPetWeightRequired, success: false)
                return false
            }
            if !isWeightValid {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationWeightInvalid, success: false)
                return false
            }
            if petSize.isEmpty {
                setAlert(message: PetCoreKitSPMStrings.petCoreVM_validationPetSizeRequired, success: false)
                return false
            }
        default:
            break
        }
        return true
    }
    

}

// MARK: - Setters
extension PetCoreViewModel {
    
    /// Reset AddPetView stepper
    public func resetCurrentStep(_ count: Int = 0) {
        currentStep = count
    }
    
    public func resetAddPetViewData() {
        self.petImage = nil
        self.petType = ""
        self.petName = ""
        self.petDescription = ""
        self.petWeight = ""
        self.petBreed = ""
        self.petAdoptionDate = Date.now
        self.petBirthday = Date.now
        self.petSize = PetCoreKitSPMStrings.petCoreVM_defaultSize
        self.petGender = PetCoreKitSPMStrings.petCoreVM_defaultGender
        self.petBirthdayStringForAPI = ""
        self.petAdoptionDateStringForAPI = ""
    }
    
    private func addAndReturnPetForCreation() -> PetModel {
        
        petBirthdayStringForAPI = dateToString(petBirthday)
        petAdoptionDateStringForAPI = dateToString(petAdoptionDate)
        
        let pet = PetModel(
            ownerID: user?.id ?? "",
            name: petName,
            breedID: petBreedID,
            breedName: petBreed,
            dateOfBirth: petBirthdayStringForAPI,
            adoptionDate: petAdoptionDateStringForAPI,
            gender: petGender,
            isLost: false,
            size: petSize,
            petType: petType,
            weightValue: PetCoreKitSPMStrings.petCoreVM_weightUnit,
            description: petDescription,
            image: petImage,
            caretakers: [""],
            weight: petWeightAsDouble,
            
        )
        
        return pet
    }
    
    public func setSelectedPet(_ pet: PetModel) {
        self.selectedPet = pet
        self.petImage = pet.image
        self.originalPetImage = pet.image
        self.hasNewImageSelected = false
    }
    
    public func setPetImage(_ image: ImageModel?) {
        self.petImage = image
    }
    
    public func setPetType(_ selectedPetType: String?) {
        guard let selectedPetType: String = selectedPetType else {
            fatalError(PetCoreKitSPMStrings.petCoreVM_errorSelectedPetTypeNil)
        }
        self.petType = selectedPetType
        print(self.petType)
    }
    
    public func setPetBreed(_ selectedPetBreed: String?, breedID: String?) {
        guard let selectedPetBreed: String = selectedPetBreed else {
            fatalError(PetCoreKitSPMStrings.petCoreVM_errorSelectedPetBreedNil)
        }
        self.petBreed = selectedPetBreed
        self.petBreedID = breedID ?? ""
        print(self.petBreed)
    }
    
    public func setPetGender(_ selectedPetGender: String?) {
        guard let selectedPetGender: String = selectedPetGender else {
            fatalError(PetCoreKitSPMStrings.petCoreVM_errorSelectedPetGenderNil)
        }
        self.petGender = selectedPetGender
        print(self.petGender)
    }
    
    public func setPetSize(_ selectedPetSize: String?) {
        guard let selectedPetSize: String = selectedPetSize else {
            fatalError(PetCoreKitSPMStrings.petCoreVM_errorSelectedPetSizeNil)
        }
        self.petSize = selectedPetSize
        print(self.petSize)
    }
    
    public func setPetBirthday(_ selectedDate: Date) {
        if let validationError: String = validateDate(selectedDate, dateType: PetCoreKitSPMStrings.petCoreVM_dateTypeBirthday) {
            self.birthdayValidationError = validationError
            setAlert(message: validationError, success: false)
        } else {
            self.birthdayValidationError = nil
            self.petBirthday = selectedDate
            print(PetCoreKitSPMStrings.petCoreVM_debugBirthdaySet.replacingOccurrences(of: "{selectedDate}", with: "\(selectedDate)"))
        }
    }
    
    public func setPetAdoptionDate(_ selectedDate: Date) {
        if let validationError: String = validateDate(selectedDate, dateType: PetCoreKitSPMStrings.petCoreVM_dateTypeAdoption) {
            self.adoptionDateValidationError = validationError
            setAlert(message: validationError, success: false)
        } else {
            self.adoptionDateValidationError = nil
            self.petAdoptionDate = selectedDate
            print(PetCoreKitSPMStrings.petCoreVM_debugAdoptionDateSet.replacingOccurrences(of: "{selectedDate}", with: "\(selectedDate)"))
        }
    }
    
    /// Sets adoption date to be the same as birthday
    public func setAdoptionDateSameAsBirthday() {
        self.petAdoptionDate = self.petBirthday
        self.adoptionDateValidationError = nil
        print(PetCoreKitSPMStrings.petCoreVM_debugAdoptionSameAsBirthday.replacingOccurrences(of: "{petBirthday}", with: "\(self.petBirthday)"))
    }
    
    /// Delete Confirmation dialog control bool
    public func setShowDeleteDialog(_ value: Bool) {
        showDeleteDialog = value
    }
    
    /// Determines if the "Same as birthday" button should be shown
    public var shouldShowSameAsBirthdayButton: Bool {
        let calendar: Calendar = Calendar.current
        let today: Date = Date()
        
        // Show button if birthday is set to a past date (valid) and not equal to adoption date
        return !calendar.isDate(petBirthday, inSameDayAs: today) && 
               petBirthday < today && 
               !calendar.isDate(petBirthday, inSameDayAs: petAdoptionDate)
    }
    
    private func setAlert(message: String, success: Bool) {
        self.alertMessage = message
        self.isSuccess = success
        self.showAlert = true
    }
}

// MARK: - Date Helpers
extension PetCoreViewModel {
    
    /// Validates that a date is not in the future or present day
    /// - Parameters:
    ///   - date: The date to validate
    ///   - dateType: The type of date being validated (for error messages)
    /// - Returns: Error message if validation fails, nil if valid
    private func validateDate(_ date: Date, dateType: String) -> String? {
        let calendar: Calendar = Calendar.current
        let today: Date = Date()
        
        // Check if date is today
        if calendar.isDate(date, inSameDayAs: today) {
            return PetCoreKitSPMStrings.petCoreVM_dateValidationToday.replacingOccurrences(of: "{dateType}", with: dateType)
        }
        
        // Check if date is in the future
        if date > today {
            return PetCoreKitSPMStrings.petCoreVM_dateValidationFuture.replacingOccurrences(of: "{dateType}", with: dateType)
        }
        
        return nil
    }
    
    /// Checks if birthday is valid (not today or future)
    public var isBirthdayValid: Bool {
        return birthdayValidationError == nil
    }
    
    /// Checks if adoption date is valid (not today or future)
    public var isAdoptionDateValid: Bool {
        return adoptionDateValidationError == nil
    }
    
    /// Checks if both dates are valid
    public var areDatesValid: Bool {
        return isBirthdayValid && isAdoptionDateValid
    }
    
    /// Validates both birthday and adoption date
    public func validateAllDates() {
        setPetBirthday(petBirthday)
        setPetAdoptionDate(petAdoptionDate)
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
                return years == 1 ? PetCoreKitSPMStrings.petCoreVM_ageOneYear : PetCoreKitSPMStrings.petCoreVM_ageMultipleYears.replacingOccurrences(of: "{years}", with: "\(years)")
            } else if months > 0 {
                return months == 1 ? PetCoreKitSPMStrings.petCoreVM_ageOneMonth : PetCoreKitSPMStrings.petCoreVM_ageMultipleMonths.replacingOccurrences(of: "{months}", with: "\(months)")
            } else {
                return PetCoreKitSPMStrings.petCoreVM_ageLessThanMonth
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
    
    // Helper method to convert Date to String for API calls
    public func dateToString(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    // Helper method to convert String to Date for display
    public func stringToDate(_ dateString: String) -> Date {
        let iso8601Formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let inputFormatter: DateFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date: Date = iso8601Formatter.date(from: dateString) {
            return date
        } else if let date: Date = inputFormatter.date(from: dateString) {
            return date
        }
        
        return Date()
    }
}

// MARK: - Weight Conversion Helper
extension PetCoreViewModel {
    
    /// Converts the petWeight string to a Double for API usage
    var petWeightAsDouble: Double {
        return Double(petWeight.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
    }
    
    /// Validates that the weight is a valid number
    var isWeightValid: Bool {
        guard !petWeight.isEmpty else { return false }
        return Double(petWeight.trimmingCharacters(in: .whitespacesAndNewlines)) != nil
    }
}
