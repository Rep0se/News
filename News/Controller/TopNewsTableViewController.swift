//
//  TopNewsTableViewController.swift
//  News
//
//  Created by Alexander Sundiev on 2019-12-19.
//  Copyright © 2019 Alexander Sundiev. All rights reserved.
//

import UIKit

class TopNewsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    let cellId = "cellId"
    var articles: Array<Article> = []
    var hasMorePages = false
    var currentPage = 1
    
    var titles: Array<String>  = []
    var authors: Array<String>  = []
    var content: Array<String> = []
    var matches: Array<Int> = []
    var searching = false
    
    // MARK: Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HeadlineTableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupNavbar()
        handleRefresh()
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl){
        // Perform actions to refresh the content
        handleRefresh()
        // and then dismiss the control
        sender.endRefreshing()
    }
    
    // MARK: - Handlers
    @objc func handleRefresh(){
        // request api service
        ApiService.shared.readAll { (response) in
            if response.totalResults > response.articles.count {
                self.hasMorePages = true
            } else {
                self.hasMorePages = false
            }
            self.currentPage = 1
            self.articles = response.articles
            self.createSearchableObjects()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func loadMore(){
        // request api service
        ApiService.shared.readPage(page: currentPage + 1) { (response) in
            if self.articles.count < response.totalResults {
                self.currentPage += 1
                self.articles += response.articles
                self.createSearchableObjects()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.hasMorePages = false
                return
            }
        }
    }
    
    // MARK: - View Setup
    private func setupNavbar(){
        navigationItem.title = "Top News"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Refresh control setup
        let refreshControl = UIRefreshControl()
        let title = "Pull to Refresh"
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Search
    private func createSearchableObjects(){
        titles = articles.map{$0.title.lowercased()}
        authors = articles.map{$0.author?.lowercased() ?? ""}
        content = articles.map{$0.content?.lowercased() ?? ""}
    }
    
    lazy var searchController: UISearchController = { [weak self] in
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Story"
        sc.searchBar.tintColor = .darkGray
        return sc
    }()
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            matches.removeAll()
            
            for index in 0..<articles.count {
                if titles[index].contains(searchText.lowercased()) || authors[index].contains(searchText.lowercased()) ||  content[index].contains(searchText.lowercased()){
                    matches.append(index)
                }
            }
             searching = true
        } else {
            searching = false
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? matches.count : articles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HeadlineTableViewCell
        let row = indexPath.row
        let article = searching ? articles[matches[row]] : articles[row]
        cell.cell = article
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count-1 && hasMorePages == true{
            loadMore()
        }
    }
}
