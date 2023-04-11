//
//  MediaTypeViewController.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import UIKit

protocol MediaTypeDisplayLogic: AnyObject {
}

final class MediaTypeViewController: BaseViewController, MediaTypeDisplayLogic {
    typealias DoneAction = ((_ selectedMediaTypes: [MediaType]) -> Void)

    override var shouldShowNavigationBar: Bool { true }
    override var navigationTitle: String { "Select media types" }

    var router: (MediaTypeRoutingLogic & MediaTypeDataPassing)?

    private var mediaTypes = MediaType.allCases
    private var selectedMediaTypes: [MediaType] = []
    private var doneAction: DoneAction?

    @IBOutlet private weak var mediaTypeTableView: UITableView!

    /// Initialize MediaTypeViewController
    /// - Parameters:
    ///   - selectedMediaTypes: [MediaType]
    ///   - doneAction: closure ((_ selectedMediaTypes: [MediaType]) -> Void)
    init(selectedMediaTypes: [MediaType] = [], doneAction: DoneAction?) {
        super.init(nibName: "MediaTypeViewController", bundle: nil)
        configurator()
        self.selectedMediaTypes = selectedMediaTypes
        self.doneAction = doneAction
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneInNavigation()
        setUpTableView()
    }

    // Add done button in right of navigtion bar
    private func addDoneInNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .plain,
                                                            target: self, action: #selector(doneBtnClicked))
    }

    /// Handle done button action on click of Done in navigation bar
    @objc private func doneBtnClicked() {
        doneAction?(selectedMediaTypes)
        router?.routeToSearchCriteria()
    }

    /// Configure table view delgate, dataasour and cell registration
    private func setUpTableView() {
        mediaTypeTableView.dataSource = self
        mediaTypeTableView.delegate = self
        mediaTypeTableView.allowsMultipleSelection = true
        mediaTypeTableView.register(UINib(nibName: String(describing: TypeSelectionTableViewCell.self), bundle: .main),
                                    forCellReuseIdentifier: String(describing: TypeSelectionTableViewCell.self))
    }

    /// Configure interactor, presenter, router
    private func configurator() {
        let viewController = self
        let router = MediaTypeRouter(viewController: viewController)
        viewController.router = router
    }
}

// MARK: - Tableview datasurce and delegate
extension MediaTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mediaTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TypeSelectionTableViewCell.self),
                for: indexPath
            ) as? TypeSelectionTableViewCell
        else { return UITableViewCell() }

        cell.setData(type: mediaTypes[indexPath.row])

        // Handling of selection state of cell
        if selectedMediaTypes.contains(mediaTypes[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMediaTypes.append(mediaTypes[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedMediaTypes.removeAll { $0 == mediaTypes[indexPath.row] }
    }
}
