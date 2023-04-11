//
//  ActivityIndicatorView.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 02/09/22.
//

import UIKit

final class ActivityIndicatorView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var loaderIndicatorView: UIActivityIndicatorView!

    /// Required Init with target view
    /// - Parameter view: target UIView
    required init(forView view: UIView) {
        super.init(frame: view.bounds)
        loadNib()
        view.addSubview(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    /// load view from nib
    private func loadNib() {
        Bundle.main.loadNibNamed("ActivityIndicatorView", owner: self, options: nil)
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(mainView)
    }
}
