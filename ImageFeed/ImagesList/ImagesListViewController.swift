//
//  ViewController.swift
//  ImageFeed
//
//  Created by Анна Перескокова on 22.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var tableView: UITableView? { get }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    // MARK: - Services
    var presenter: ImagesListPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - UI Elements
    @IBOutlet var tableView: UITableView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = 200
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard let image = presenter?.photos[indexPath.row] else { return }
            let imageUrl = URL(string: image.fullImageURL)
            viewController.fullImageURL = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        guard let tableView else { return }
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = presenter?.photos.count ?? 0
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        } else {
            print("Forcing reloadData because counts are equal: \(oldCount)")
            tableView.reloadData()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = presenter?.photos[indexPath.row] else { return 200 }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let testMode = ProcessInfo.processInfo.arguments.contains("testMode")
        if testMode {
            if indexPath.row == 9 {
                presenter?.loadImages()
            }
        } else {
            guard let count = presenter?.photos.count else { return }
            if indexPath.row == count - 1 {
                presenter?.loadImages()
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Could not cast cell to ImagesListCell at row \(indexPath.row)")
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        print("Building cell at row \(indexPath.row)")
        return imageListCell
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = presenter?.photos[indexPath.row] else { return }
        let imageUrl = URL(string: image.thumbImageURL)
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder.jpeg"))
        cell.cellImage.kf.indicatorType = .activity
        guard let date = image.createdAt else { return }
        cell.dateLabel.text = dateFormatter.string(from: date)
        let isLiked = image.isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        
        presenter?.didTapLike(at: indexPath) { [weak self] success in
            guard let self else { return }
            
            if success,
               let newImage = self.presenter?.photos[indexPath.row] {
                cell.setIsLiked(cell: cell, newImage.isLiked)
                print("Photo is liked: \(newImage.isLiked)")
            } else {
                let alert = UIAlertController(title: "Ошибка",
                                              message: "Что-то пошло не так",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                self.present(alert, animated: true)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
