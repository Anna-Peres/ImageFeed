//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 12.05.2025.
//

@testable import ImageFeed
import Foundation
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    func updateAvatarUrl() -> URL? {
        return nil
    }
    
    func getProfile() -> ImageFeed.Profile? {
        return nil
    }
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var updateProfileCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
  
    func updateProfile() {
        updateProfileCalled = true
    }
}
