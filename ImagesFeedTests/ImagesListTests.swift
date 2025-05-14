//
//  ImagesListTests.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 14.05.2025.
//

@testable import ImageFeed
import Foundation
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateImagesList() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.updateImagesListCalled)
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photos: [ImageFeed.Photo] = []
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    
    func loadImages() {
    }
    
    func didTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    var updateImagesListCalled: Bool = false
    
    func updateImagesList() {
        updateImagesListCalled = true
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var tableView: UITableView?
    var presenter: ImageFeed.ImagesListPresenterProtocol?

    func updateTableViewAnimated() {
    }
}



