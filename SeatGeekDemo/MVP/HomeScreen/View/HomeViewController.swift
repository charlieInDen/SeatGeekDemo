//
//  HomeViewController.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    lazy var slideTransitioningDelegate: SlideInPresentationManager = SlideInPresentationManager()
    let searchController = UISearchController(searchResultsController: nil)
    private var presenter: HomePresenter!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return refreshControl
    }()
    var selectedIndex: IndexPath?

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!

    // MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    // MARK: - Functions
    private func initialSetup() {
        setUpNavigationTitle()
        presenterSetup()
        setUpSearchController()
        registerTableCell()
        setupTableView()
        getAllEventData()
        registerForPreviewing(with: self, sourceView: tableView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        if  let indexPatch = selectedIndex {
            self.tableView.reloadRows(at: [indexPatch], with: .none)
        }
    }

    /// Function to setup navigation title
    private func setUpNavigationTitle() {
        self.navigationController?.navigationBar.isHidden = true
        let barColor = UIColor(red: 18.0/255.0, green: 45.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.tintColor = barColor
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = true
    }

    /// Function to setup presenter
    private func presenterSetup() {
        self.presenter = HomePresenter(with: self)
    }

    /// Function to setup search controller
    private func setUpSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.white
        // TextField Color Customization
        if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.black])
            if let backgroundview = textFieldInsideSearchBar.subviews.first {

                // Background color
                backgroundview.backgroundColor = UIColor.white

                // Rounded corner
                backgroundview.layer.cornerRadius = 5
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    /// Function to register table cell
    private func registerTableCell() {
        self.tableView.register(ProductTableViewCell.self)
    }

    /// Function to setup table view
    private func setupTableView() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    /// Function to handle pull to refresh
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        presenter.reset()
        presenter.getAllEventsList()
        refreshControl.endRefreshing()
    }

    /// Function to get all event data
    private func getAllEventData() {
        presenter.getAllEventsList()
    }

    /// Function to check if search bar is empty or not
    /// - Returns: bool
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    /// Function to filter search text
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        presenter.reset()
        presenter.isFiltering = searchController.isActive && !searchBarIsEmpty()
        presenter.getFilteredList(forText: searchText) { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {

    // MARK: - Tableview methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        rowCount = self.presenter.numberOfRows

        if rowCount > 0 {
            self.noResultLabel.isHidden = true
        } else {
            self.noResultLabel.isHidden = false
        }
        return rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let cellModel = presenter.getEventsDataModelAtIndex(index: indexPath.row) {
            let eventIndexData: SGEvent
            eventIndexData = cellModel

            cell.setupData(model: eventIndexData)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = presenter.getEventsDataModelAtIndex(index: indexPath.row),
            let vc = DetailViewController.instantiateFromMainStoryboard() {
            vc.event = cellModel
            selectedIndex = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductTableViewCell.height
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if (tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height - 20 {
            presenter.paginationHit()
        }
    }

    private func createDetailViewControllerIndexPath(indexPath: IndexPath) -> DetailViewController {

        let detailViewController = DetailViewController(nibName: DetailViewController.identifier, bundle: nil)
        if let cellModel = presenter.getEventsDataModelAtIndex(index: indexPath.row) {
            detailViewController.event = cellModel
        }
        return detailViewController
    }

    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        let detailViewController = createDetailViewControllerIndexPath(indexPath: indexPath)
        selectedIndex = indexPath
        return detailViewController
    }

    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

extension HomeViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension HomeViewController: HomePresenterProtocol, AlertViewProtocol {

    func reloadTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }

    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
// Helper function 
private func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
