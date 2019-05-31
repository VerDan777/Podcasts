//
//  EpisodesController.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import Foundation
import UIKit
import FeedKit
import AVKit

class EpisodesController: UITableViewController {
    
    var episodes = [1,2,3];
    var trackPrice: Float!;
    
    var playerView: UIView!;
    var playerLayer: AVPlayerLayer!;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.register(EpisodeCell.self, forCellReuseIdentifier: "cellID1");
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil);
        
        tableView.register(nib, forCellReuseIdentifier: "cellID1");
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "favorite", style: .plain, target: self, action: #selector(handleFavorite)),
            UIBarButtonItem(title: "restore", style: .plain, target: self, action: #selector(handleRestore))
        ];
        
//        setupVideo();
    };
    
    @objc func handleFavorite() {
//        NSKe
        let nowTrack = Track(trackName: "1", image: "appicon");
        let data = NSKeyedArchiver.archivedData(withRootObject: nowTrack);
        
        UserDefaults.standard.set(data, forKey: "favorite");
    };
    
    @objc func handleRestore() {
        let data = UserDefaults.standard.data(forKey: "favorite");
        guard let podcast = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Track else { return };
        
        guard let track = podcast.trackName else { return };
        print(track);
        
    }
    
    fileprivate func setupVideo() {
        playerView = UIView();
        playerView.frame = CGRect(x: self.view.bounds.width - 112, y: self.view.bounds.height - (tabBarController?.tabBar.bounds.size.height)! - 220, width: 100, height: 150);
        self.playerView.bringSubviewToFront(playerView);
        self.view.addSubview(playerView);
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!;
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.playerView.bounds;
        playerLayer.videoGravity = .resizeAspectFill
        
        self.playerView.layer.insertSublayer(playerLayer, at: 0);
        
        player.play();
        
        playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGet)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap));
        tap.numberOfTapsRequired = 2;
        self.playerView.addGestureRecognizer(tap)
    }
    
    @objc func tapGet(_ sender: Any) {
        UIView.animate(withDuration: 0.75) {
            self.playerView.frame = CGRect(x: 0, y: 0, width: 500, height: 500);
            self.playerLayer.frame = self.playerView.bounds;
            
        }
    }
    
    @objc func doubleTap(_ sender: Any) {
        UIView.animate(withDuration: 0.75) {
            self.playerView.frame = CGRect(x: self.view.bounds.width - 112, y: self.view.bounds.height - (self.tabBarController?.tabBar.bounds.size.height)! - 212, width: 100, height: 100);
            self.playerLayer.frame = self.playerView.bounds;
        }
    }
    
    var podcast: Podcast! {
        didSet {
            navigationItem.title = podcast?.trackName;
            fetchEpisodes();
        }
    }
    
    func fetchEpisodes() {
       guard let feedURL = podcast?.feedUrl else { return };

        let parser = FeedParser(URL: URL(string: feedURL)!);
        parser!.parseAsync(result: { (result) in
            print("Success", result.isSuccess);
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID1", for: indexPath) as! EpisodeCell;
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MMM dd, yyyy";
        
        cell.episodeTrackName?.text = self.podcast.trackName;
        cell.episodeCost.text = "\(self.podcast.trackPrice ?? 0.0)";
        cell.episodeTime.text = "\(dateFormatter.string(from:  self.podcast.trackTimeMillis ?? Date()))";
        cell.episodeImage.sd_setImage(with: URL(string: self.podcast.artworkUrl100), completed: nil);
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let window = UIApplication.shared.keyWindow;
        
        let playerDetailsView = Bundle.main.loadNibNamed("PlayerView", owner: nil, options: nil)?.first as! PlayerView;
        playerDetailsView.info = Track(trackName: self.podcast.trackName, image: self.podcast.artworkUrl100);
        playerDetailsView.frame = self.view.frame;
        window?.addSubview(playerDetailsView);
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count;
    }
    
}
