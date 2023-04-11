//
//  SearchCriteriaViewController.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 30/08/22.
//

import UIKit

protocol SearchCriteriaDisplayLogic: BaseDisplayLogic {
    func displaySelected(mediaTypes: [MediaType])
    func displayError(message: String)
    func displaySearchResult()
}

final class SearchCriteriaViewController: BaseViewController, SearchCriteriaDisplayLogic {

    override var shouldShowNavigationBar: Bool { true }

    private var selectedMediaTypes: [MediaType] = []
    // sizingCell used for calculation of cell size
    private var sizingCell: TypeCollectionViewCell?

    var interactor: SearchCriteriaBusinessLogic?
    var router: (SearchCriteriaRoutingLogic & SearchCriteriaDataPassing)?

    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var typeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    init() {
        super.init(nibName: "SearchCriteriaViewController", bundle: nil)
        configurator()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func configureView() {
        searchTextField.delegate = self
        configureTypeCollectionView()
    }

    /// Configure type collectionview, register cell, confirm delegate & datasource
    private func configureTypeCollectionView() {
        let identifier = String(describing: TypeCollectionViewCell.self)
        typeCollectionView.register(UINib(nibName: identifier, bundle: nil),
                                    forCellWithReuseIdentifier: identifier)
        sizingCell = UINib(nibName: identifier, bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as? TypeCollectionViewCell
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
    }

    /// Configure interactor, presenter, router
    private func configurator() {
        let viewController = self
        let presenter = SearchCriteriaPresenter(viewController: viewController)
        let interactor = SearchCriteriaInteractor(presenter: presenter, worker: SearchCriteriaWorker())
        let router = SearchCriteriaRouter(viewController: viewController, dataStore: interactor)
        viewController.router = router
        viewController.interactor = interactor
    }

    /// Validate the input
    /// - Returns: Bool
    private func validateInput() -> Bool {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            showError("Please enter search text")
            return false
        }
        guard selectedMediaTypes.count > 0 else {
            showError("Please select atleast one media type")
            return false
        }
        return true
    }

    private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }

    // MARK: - Display logic handling
    func displaySelected(mediaTypes: [MediaType]) {
        selectedMediaTypes = mediaTypes
        typeCollectionView.reloadData()
    }

    func displayError(message: String) {
        showError(message)
    }

    func displaySearchResult() {
        router?.routeToSearchResult()
    }

    // MARK: - IBActions
    @IBAction private func selectMediaType(_ sender: UIButton) {
        dismissKeyboard()
        router?.routeToMediaType()
    }

    @IBAction private func submitBtnClicked(_ sender: UIButton) {
        dismissKeyboard()
        guard validateInput(), let searchText = searchTextField.text else {
            return
        }
        let requests = selectedMediaTypes.map {
            SearchList.SearchItunes.Request(term: searchText, type: $0)
        }
        interactor?.getSearchResult(for: requests)
    }
}

// MARK: - Textfield delagte
extension SearchCriteriaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

// MARK: - Collection view datasource and flowlayoutdelegate
extension SearchCriteriaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedMediaTypes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TypeCollectionViewCell.self),
                for: indexPath
            ) as? TypeCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setData(type: selectedMediaTypes[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        calculateSize(type: selectedMediaTypes[indexPath.item])
    }

    /// Calculate the size of collection cell using reference cell
    /// - Parameter type: Type
    /// - Returns: reference size
    private func calculateSize(type: MediaType) -> CGSize {
        sizingCell?.setData(type: type)
        return sizingCell?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? .zero
    }
}
