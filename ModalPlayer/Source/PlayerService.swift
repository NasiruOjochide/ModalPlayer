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
    var musicIndex = 0
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
    
    private func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            print("deactivation successful")
        } catch {
            print("failed to deactivate audio session \(error.localizedDescription)")
        }
    }
    
    func startAudio(track: TrackModel) {
        //activate our session before playing audio
        
        activateSession()
        
        loadMusic(track: track)
        
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
    
    func play() {
        guard let player else { return }
        player.play()
        musicIsPlaying = true
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
        musicIsPlaying = false
        if let token = timeOberserToken {
            player.removeTimeObserver(token)
            timeOberserToken = nil
        }
    }
    
    private func getAudioDuration() -> Double {
        return player?.currentItem?.duration.seconds ?? 1
    }
    
    func rewindAction() {
        guard !musicTracks.isEmpty else { return }
        if musicIsPlaying {
            rewindOnMusicPlaying()
        } else {
            rewindOnMusicPaused()
        }
    }
    
    private func loadPreviousMusic() {
        pause()
        musicIndex -= 1
        loadMusic(track: musicTracks[musicIndex])
    }
    
    private func rewindOnMusicPaused() {
        guard let player else { return }
        if musicIndex > 0 {
            loadPreviousMusic()
        } else {
            player.currentItem?.seek(to: .zero, completionHandler: nil)
        }
    }
    
    private func rewindOnMusicPlaying() {
        guard let player,
              let currentTime = player.currentItem?.currentTime().seconds else { return }
        if currentTime < 4 && musicIndex > 0 {
            loadPreviousMusic()
            play()
        } else {
            player.currentItem?.seek(to: .zero, completionHandler: nil)
        }
    }
    
    func nextMusic() {
        guard let _ = player,
              !musicTracks.isEmpty else { return }
        if musicIndex < (musicTracks.count - 1) && musicIndex >= 0 {
            pause()
            musicIndex += 1
            loadMusic(track: musicTracks[musicIndex])
            play()
        }
    }
    
    private func loadMusic(track: TrackModel) {
        let trackURL = URL(string: track.trackURL)
        guard let trackURL else { return }
        currentTrack = track
        musicProgressPublisher.send(0)
        let playerItem = AVPlayerItem(url: trackURL)
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
}
