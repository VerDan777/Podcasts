//
//  PodcastCell.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {

    @IBOutlet weak var podcastImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            self.trackNameLabel.text = podcast.trackName;
            self.artistNameLabel.text = podcast.artistName;
            self.episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes";
            
            guard let url = URL(string: podcast.artworkUrl100 ?? "") else { return } ;
            self.podcastImageView.sd_setImage(with: url, completed: nil);
        }
    }
    
}
