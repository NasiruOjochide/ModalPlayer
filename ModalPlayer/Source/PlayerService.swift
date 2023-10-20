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
    
    @Published var musicIsPlaying: Bool = false
    @Published var trackReadyToPlay: Bool = false
    @Published var currentTrack: TrackModel?
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var cancellableSet = Set<AnyCancellable>()
    private var timeOberserToken: Any?
    private var musicIndex = 0
    var musicTracks: [TrackModel] = []
    let musicProgressPublisher = PassthroughSubject<TimeInterval, Never>()
    
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
                        self.musicIsPlaying = false
                        self.musicProgressPublisher.send(0)
                        self.trackReadyToPlay = false
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
                self.musicProgressPublisher.send(progress)
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
        guard let player,
        let currentTime = player.currentItem?.currentTime().seconds else { return }
        if currentTime < 4 && musicIndex > 0 {
            player.pause()
            musicIndex -= 1
            loadMusic()
            play()
        } else {
            player.currentItem?.seek(to: .zero, completionHandler: nil)
        }
        
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
        guard musicIndex < musicTracks.count,
              let trackURL = URL(string: musicTracks[musicIndex].url) else { return }
        currentTrack = musicTracks[musicIndex]
        let playerItem = AVPlayerItem(url: trackURL)
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
}
