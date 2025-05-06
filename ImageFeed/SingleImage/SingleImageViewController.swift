//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 01.03.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Services
    var fullImageURL: URL?
    private var image: UIImage?
    
    // MARK: - UI Elements
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setImage()
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = imageSize.width != 0 ? visibleRectSize.width / imageSize.width : 0
        let vScale = imageSize.height != 0 ? visibleRectSize.height / imageSize.height : 0
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.contentMode = .center
        imageView.kf.setImage(with: fullImageURL,
                              placeholder: UIImage(named: "placeholder")) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            self.imageView.contentMode = .scaleToFill
            switch result {
            case .success(let imageResult):
                image = imageResult.image
                guard let image = image else { return }
                imageView.frame.size = image.size
                rescaleAndCenterImageInScrollView(image: image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
            
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.setImage()
        })
        self.present(alert, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
