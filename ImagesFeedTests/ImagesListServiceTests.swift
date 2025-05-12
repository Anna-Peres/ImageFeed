////
////  ImagesFeedTests.swift
////  ImagesFeedTests
////
////  Created by Анна Перескокова on 01.05.2025.
////
//
//@testable import ImageFeed
//import XCTest
//
//final class ImagesListServiceTests: XCTestCase {
//    func testExample() {
//        }
//    func testFetchPhotos() {
//        let service = ImagesListService()
//        
//        let expectation = self.expectation(description: "Wait for Notification")
//        NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification,
//            object: nil,
//            queue: .main) { _ in
//                expectation.fulfill()
//            }
//        
//        service.fetchPhotosNextPage(completion: { _ in })
//        wait(for: [expectation], timeout: 10)
//        
//        XCTAssertEqual(service.images.count, 10)
//    }
//}
