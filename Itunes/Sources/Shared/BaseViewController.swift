//
//  BaseViewController.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import UIKit

/// Base view controller class
class BaseViewController: UIViewController {
    // Bool to show/hide navigation bar
    var shouldShowNavigationBar: Bool { false }

    // navigation bar title
    var navigationTitle: String { "" }

    // gradient to be applied on background
    lazy private var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [UIColor.cyan.cgColor, UIColor.blue.cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 1.8, 1.0]
        return gradient
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientView()
        setUpNavigation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
    }

    /// Navigation setup
    func setUpNavigation() {
        navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: true)
        title = navigationTitle
    }

    /// Display error in alertview
    /// - Parameter errorMsg: error message
    func showError(_ errorMsg: String) {
        let alertController = UIAlertController(title: "Error!", message: errorMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    /// Add gradient in background
    private func configureGradientView() {
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: - Loader handling
extension BaseViewController {
    func showLoader() {
        view.showIndicator()
    }

    func hideLoader() {
        view.hideIndicator()
    }
}
