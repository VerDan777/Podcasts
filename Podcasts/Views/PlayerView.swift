//
//  PlayerView.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class Track: NSObject, NSCoding, Codable {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(trackName ?? "", forKey: "trackName");
        aCoder.encode(image ?? "", forKey: "image");
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.trackName = aDecoder.decodeObject(forKey: "trackName") as? String;
        self.image = aDecoder.decodeObject(forKey: "image") as? String;
    }
    
    let trackName: String?
    let image: String?
    
    init(trackName: String?, image: String? ) {
        self.trackName = trackName ?? "";
        self.image = image ?? "";
    }
}

class PlayerView: UIView {
    @IBAction func hanleTap(_ sender: Any) {
        self.removeFromSuperview();
    }
    
    var player: AVPlayer = {
        let avPlayer = AVPlayer();
        avPlayer.automaticallyWaitsToMinimizeStalling = true;
        return avPlayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        setupCategory();

        guard let url = URL(string: "https://cdn.drivemusic.me/dl/online/rGO-IeLg7rOrWyKoAEijqw/1558240460/download_music/2016/10/markul-obladaet-poslednii-bilet.mp3") else { return };
        
        let playerItem = AVPlayerItem(url: url);
        player.replaceCurrentItem(with: playerItem);
        
        // SetTimeout
//        let time = CMTimeMake(value: 1,timescale: 3);
//        let times = [NSValue(time: time)];
        
        // SetInterval
        let interval = CMTimeMake(value: 1, timescale: 2);
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            
             self.setupMediaControl();
//            let totalSeconds = CMTimeGetSeconds(time);
//            print(totalSeconds);
//            let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
//            let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60);
//            self.currentTimeLabel.text = "\(minutes):\(seconds)";
            
//            let timeSeconds = CMTimeGetSeconds((self.player.currentItem?.duration)!);
//            let secondsTotal = Int(timeSeconds.truncatingRemainder(dividingBy: 60));
//            let minutesTotal = Int(timeSeconds.truncatingRemainder(dividingBy: 3600) / 60);
//
//            self.durationLabel.text = "\(minutesTotal):\(secondsTotal)";
            
            self.updateSlider();
        }
    }
    
    fileprivate func setupMediaControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents();
        let commandCenter = MPRemoteCommandCenter.shared();
        
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Последний билет";
        nowPlayingInfo[MPMediaItemPropertyArtist] = "OBLADAET";
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(self.player.currentItem!.duration);
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(self.player.currentTime())
        
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: UIImage(named: "appicon")!.size, requestHandler: { (ima) -> UIImage in
            return UIImage(named: "taglife1")!
        })
        
        commandCenter.playCommand.isEnabled = true;
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal);
            return .success
        }
        
//        FileManager.default.url
        
        commandCenter.pauseCommand.isEnabled = true;
        
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            return .success
        }

        commandCenter.nextTrackCommand.isEnabled = true;
        
        commandCenter.nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo;
        
    }
    
    fileprivate func updateSlider() {
        let duration = CMTimeGetSeconds(self.player.currentItem!.duration);
        let currentTime = CMTimeGetSeconds(self.player.currentTime());
        
        let percantage = currentTime / duration;
        self.sliderChangeTime.value = Float(percantage);
    }
    
    fileprivate func setupCategory() {
        let audioSession = AVAudioSession.sharedInstance();

        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true);
        } catch let sessionErr {
            print("sessionErr", sessionErr);
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        }
    }
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBAction func slider(_ sender: Any) {
        let percentage = self.sliderChangeTime.value;
        
        let durationSeconds = CMTimeGetSeconds(self.player.currentItem!.duration);
        
        let seekTimeSeconds = Float64(percentage) * durationSeconds;
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: Int32(NSEC_PER_SEC));
        
        self.player.seek(to: seekTime);
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        let fifteenSeconds = CMTimeMake(value: 15, timescale: 1);
        let seekTime = CMTimeSubtract(self.player.currentTime(), fifteenSeconds);
        
        self.player.seek(to: seekTime);
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        let fifteenSeconds = CMTimeMake(value: 15, timescale: 1);
        
        let seekTime = CMTimeAdd(self.player.currentTime(), fifteenSeconds);
        
        self.player.seek(to: seekTime);
    };
    
    @IBAction func sliderVolume(_ sender: UISlider) {
        self.player.volume = sender.value;
    }
    
    @IBOutlet weak var sliderChangeTime: UISlider!
    @objc func handlePlay() {
        if player.timeControlStatus == .paused {
            player.play();

            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.episodeImageView.transform = .identity;
            }, completion: nil)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            player.pause();
            UIView.animate(withDuration: 0.3) {
                self.episodeImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
            }
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    fileprivate func playEpisode() {
        guard let url = URL(string: "https://cdn.drivemusic.me/dl/online/rGO-IeLg7rOrWyKoAEijqw/1558240460/download_music/2016/10/markul-obladaet-poslednii-bilet.mp3") else { return };
        
        let playerItem = AVPlayerItem(url: url);
        player.replaceCurrentItem(with: playerItem);
        player.play();
    };
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            let scale: CGFloat = 0.7;
            episodeImageView.layer.cornerRadius = 5;
            episodeImageView.layer.masksToBounds = true;
            episodeImageView.clipsToBounds = true;
            episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale);
        }
    }
    
    @IBOutlet weak var episodeTitle: UILabel!
    
    var info: Track! {
        didSet {
            self.episodeTitle.text = info.trackName;
            self.episodeImageView.sd_setImage(with: URL(string: info.image ?? "")!, completed: nil);
        }
    }
}
