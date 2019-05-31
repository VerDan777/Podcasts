//
//  PodscastsSearchController.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PodcastsSearchViewController: UITableViewController, UISearchBarDelegate  {

    var dummyPodscasts = [Podcast]();
    var isSearching = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupBar();
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID");
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil);
        
        tableView.register(nib, forCellReuseIdentifier: "cellID");
        
        tableView.tableFooterView = UIView();
        
    }
    
    //Mark:- UITableView
    fileprivate func setupBar() {
        self.definesPresentationContext = true;
        let searchController = UISearchController(searchResultsController: nil);
        navigationItem.searchController = searchController;
        navigationItem.hidesSearchBarWhenScrolling = false;
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchBar.delegate = self;
        
        searchBar(searchController.searchBar, textDidChange: "text");
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
        isSearching = true;
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            APIService.fetchPodcasts(searchText: searchText) { (data) in
                self.isSearching = false;
                print(data);
                self.dummyPodscasts = data;
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            };
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! PodcastCell;
        
        
        let podcast = self.dummyPodscasts[indexPath.row];
        
        cell.podcast = podcast;
//        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")";
//        cell.textLabel?.numberOfLines = -1;
//        cell.imageView?.image = UIImage(named: "appicon");
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel();
        label.text = "Please enter search term";
        label.textAlignment = .center;
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold);
        return label;
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(isSearching) {
            
            let activityIn = UIActivityIndicatorView(style: .whiteLarge);
            activityIn.color = .darkGray;
            activityIn.startAnimating();
            return activityIn;
        }
        return nil;
//        let activityIn = UIActivityIndicatorView(style: .whiteLarge);
//        activityIn.color = .darkGray;
//        activityIn.startAnimating();
//        return activityIn;
//        return nil;
    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return self.dummyPodscasts.count > 0 ? 0 : 200;
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath);
        let episodes = EpisodesController();
        episodes.podcast = self.dummyPodscasts[indexPath.row];
        navigationController?.pushViewController(episodes, animated: true);
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dummyPodscasts.count > 0 ? 0 : 250;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dummyPodscasts.count;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132;
    }
    
}

