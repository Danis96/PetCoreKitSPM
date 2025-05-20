//
//  PetCoreCoordinator.swift
//  PetCoreKitSPM
//
//  Created by Danis Preldzic on 20. 5. 2025..
//

import SwiftUI
import Factory
import SQAUtility

@MainActor
public final class PetCoreCoordinator: CoordinatorProtocol {
    
    
    public static let shared = PetCoreCoordinator()
    
    // MARK: - Protocol Requirements
    public typealias Route = PetCoreRoute
    @Published public var path = NavigationPath()
    
    // MARK: - View Models
//    @Published public private(set) var imageKitViewModel: ImageKitViewModel
    
    // MARK: - Navigation
    @Published public var sheet: PetCoreRoute?
    
    private init() {
//        self.imageKitViewModel = ImageKitViewModel()
    }
    
    // MARK: - CoordinatorProtocol Methods
    public func start(onComplete: @escaping () -> Void) -> AnyView {
        print("Starting Whiskr Image Coordinator")
        return AnyView(
            Text("Pet core coordinator")
//            ImageKitPicker(selectedImage: imageKitViewModel.selectedImage,
//                           placeholderText: "Select an image")
//            .environmentObject(imageKitViewModel)
//            .environmentObject(self)
        )
    }
    
    public func navigate(to route: PetCoreRoute) {
        path.append(route)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    public func present(_ route: PetCoreRoute) {
        sheet = route
    }
    
    public func dismissSheet() {
        sheet = nil
    }
}

