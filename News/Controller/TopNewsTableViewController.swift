//
//  TopNewsTableViewController.swift
//  News
//
//  Created by Alexander Sundiev on 2019-12-19.
//  Copyright © 2019 Alexander Sundiev. All rights reserved.
//

import UIKit

class TopNewsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let cellId = "cellId"
    var articles: Array<Article> = []
    var hasMorePages = false
    var currentPage = 1
    
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
        
        // Refresh control setup
        let refreshControl = UIRefreshControl()
        let title = "Pull to Refresh"
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HeadlineTableViewCell
        let article = articles[indexPath.row]
        cell.cell = article
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count-1 && hasMorePages == true{
            loadMore()
        }
    }
}
