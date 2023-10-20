//
//  PlayerService.swift
//  ModalPlayer
//
//  Created by Danjuma Nasiru on 28/09/2023.
//

import AVFoundation
import Combine
import Foundation

class PlayerService: ObservableObject {
    
    @Published var isPlaying: Bool = false
    @Published var musicLoaded: Bool = false
    @Published var musicTracks: [TrackModel] = []
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var session = AVAudioSession.sharedInstance()
    private var cancellableSet = Set<AnyCancellable>()
    private var timeOberserToken: Any?
    private var musicURL: URL?
    private var musicIndex = 0
    let publisher = PassthroughSubject<TimeInterval, Never>()
    
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
        if !musicTracks.isEmpty {
            activateSession()
            
            loadMusic()
            
            NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
                .sink { [weak self] _ in
                    guard let self else{ return }
                    if self.musicIndex == (self.musicTracks.count - 1) {
                        self.isPlaying = false
                        self.publisher.send(0)
                        self.musicLoaded = false
                        self.deactivateSession()
                    } else {
                        self.nextMusic()
                    }
                }
                .store(in: &cancellableSet)
            
            play()
        }
    }
    
    func play() {
        guard let player else { return }
        player.play()
        timeOberserToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self else { return }
            if time.seconds < self.getAudioDuration() {
                let progress = time.seconds / self.getAudioDuration()
                self.publisher.send(progress)
            }
        }
    }
    
    func pause() {
        guard let player else { return }
        player.pause()
        if let token = timeOberserToken {
            player.removeTimeObserver(token)
            timeOberserToken = nil
        }
    }
    
    func getAudioDuration() -> Double {
        return player?.currentItem?.duration.seconds ?? 1
    }
    
    func rewindMusic() {
        guard let player else { return }
        player.currentItem?.seek(to: .zero, completionHandler: nil)
    }
    
    func nextMusic() {
        guard let player else { return }
        if musicIndex < (musicTracks.count - 1) {
            player.pause()
            musicIndex += 1
            loadMusic()
            play()
        }
    }
    
    func loadMusic() {
        musicURL = URL(string: musicTracks[musicIndex].url)
        playerItem = AVPlayerItem(url: musicURL!)
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
}
