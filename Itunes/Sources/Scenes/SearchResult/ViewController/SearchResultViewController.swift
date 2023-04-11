//
//  SearchResultViewController.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import UIKit

protocol SearchResultDisplayLogic: AnyObject {
    func displaySearchResult(viewModel: ShowSearchResult.GetSearchResult.ViewModel)
    func displaySearchDetail()
}

final class SearchResultViewController: BaseViewController, SearchResultDisplayLogic {

    // Layout enum
    enum LayoutType {
        case list
        case grid
    }

    override var shouldShowNavigationBar: Bool { true }
    override var navigationTitle: String { "Search Result" }

    private var selectedLayout: LayoutType = .grid
    private var viewModel: ShowSearchResult.GetSearchResult.ViewModel?

    var interactor: SearchResultBusinessLogic?
    var router: (SearchResultRoutingLogic & SearchResultDataPassing)?

    @IBOutlet weak private var searchResultCollectionView: UICollectionView!

    init() {
        super.init(nibName: "SearchResultViewController", bundle: nil)
        configurator()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()

        // to get all the search results
        interactor?.getSearchResult()
    }

    /// Configure collectionview, register cell, confirm delegate & datasource
    private func configureCollectionView() {
        let headerIdentifier = String(describing: HeaderCollectionReusableView.self)
        searchResultCollectionView.register(UINib(nibName: headerIdentifier, bundle: nil),
                                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                            withReuseIdentifier: headerIdentifier)
        let gridCellIdentifier = String(describing: GridCollectionViewCell.self)
        searchResultCollectionView.register(UINib(nibName: gridCellIdentifier, bundle: nil),
                                            forCellWithReuseIdentifier: gridCellIdentifier)
        let listCellIdentifier = String(describing: ListCollectionViewCell.self)
        searchResultCollectionView.register(UINib(nibName: listCellIdentifier, bundle: nil),
                                            forCellWithReuseIdentifier: listCellIdentifier)
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.delegate = self
    }

    /// Configure interactor, presenter, router
    private func configurator() {
        let viewController = self
        let presenter = SearchResultPresenter(viewController: viewController)
        let interactor = SearchResultInteractor(presenter: presenter)
        let router = SearchResultRouter(viewController: viewController, dataStore: interactor)
        viewController.router = router
        viewController.interactor = interactor
    }

    func displaySearchResult(viewModel: ShowSearchResult.GetSearchResult.ViewModel) {
        self.viewModel = viewModel
        searchResultCollectionView.reloadData()
    }

    func displaySearchDetail() {
        router?.routeToSearchDetail()
    }

    // MARK: - IBAction's
    @IBAction private func layoutChangeClicked(_ sender: UISegmentedControl) {
        selectedLayout = sender.selectedSegmentIndex == 0 ? .grid : .list
        searchResultCollectionView.reloadData()
    }
}

// MARK: - Collection view delegate and datasource
extension SearchResultViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.displayedResults.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.displayedResults[section].items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch selectedLayout {
        case .grid:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: GridCollectionViewCell.self),
                    for: indexPath
                ) as? GridCollectionViewCell,
                let item = viewModel?.displayedResults[indexPath.section].items[indexPath.item]
            else { return UICollectionViewCell() }
            cell.setData(artwork: item)
            return cell
        case .list:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ListCollectionViewCell.self),
                    for: indexPath
                ) as? ListCollectionViewCell,
                let item = viewModel?.displayedResults[indexPath.section].items[indexPath.item]
            else { return UICollectionViewCell() }
            cell.setData(artwork: item)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        switch selectedLayout {
        case .list: return CGSize(width: width, height: 105)
        case .grid: return CGSize(width: width/3, height: 187.0)
        }
    }

    func collectionView( _ collectionView: UICollectionView,
                         viewForSupplementaryElementOfKind kind: String,
                         at indexPath: IndexPath ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(HeaderCollectionReusableView.self)",
                for: indexPath
            )
            guard let typedHeaderView = headerView as? HeaderCollectionReusableView else { return headerView }
            guard let type = viewModel?.displayedResults[indexPath.section].type else { return typedHeaderView }
            typedHeaderView.setData(type: type)
            return typedHeaderView
        default:
            assert(false, "Invalid element type")
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.searchItemSelection(indexPath: indexPath)
    }
}
