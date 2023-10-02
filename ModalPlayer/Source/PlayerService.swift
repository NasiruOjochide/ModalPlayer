//
//  PlayerService.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 28/09/2023.
//

import AVFoundation
import Combine
import Foundation

class PlayerService {
    
    static let shared = PlayerService()
    
    private init() {}
    
    deinit {
        cancellable?.cancel()
    }
    
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var cancellable: AnyCancellable?
    private var audioPlayer: AVAudioPlayer?
    var timeOberserToken: Any?
    let publisher = PassthroughSubject<TimeInterval, Never>()
    let musicEnded = PassthroughSubject<Bool, Never>()
    
    private func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}
        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
    }
    
    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            print("deactivation successful")
        } catch {
            print("failed to deactivate audio session \(error.localizedDescription)")
        }
    }
    
    func startAudio() {
        //activate our session before playing audio
        activateSession()
        
        let url = URL(string: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3")
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        cancellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                guard let self = self else{ return }
                self.deactivateSession()
            }
        
        play()
    }
    
    func play() {
        if let player = player {
            player.play()
            timeOberserToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
                guard let self = self else { return }
                if time.seconds == self.getAudioDuration() {
                    player.seek(to: .zero)
                    self.publisher.send(0)
                    self.musicEnded.send(true)
                } else {
                    let progress = time.seconds / self.getAudioDuration()
                    self.publisher.send(progress)
                }
            }
        }
    }
    
    func pause() {
        if let player = player {
            player.pause()
            if let token = timeOberserToken {
                player.removeTimeObserver(token)
                timeOberserToken = nil
            }
        }
    }
    
    func getAudioDuration() -> Double {
        guard let player = player else { return 100 }
        return player.currentItem?.duration.seconds ?? 1        
    }
    
}
