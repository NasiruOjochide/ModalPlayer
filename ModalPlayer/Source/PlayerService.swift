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
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var session = AVAudioSession.sharedInstance()
    private var cancellableSet = Set<AnyCancellable>()
    private var timeOberserToken: Any?
    private var musicURL: URL?
    private var musicIndex = 0
    let publisher = PassthroughSubject<TimeInterval, Never>()
    let allMusic: [String] = [
        "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3",
        "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3",
        "https://file-examples.com/storage/fef431be58652d8e49c225d/2017/11/file_example_MP3_700KB.mp3"
    ]
    
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
        
        loadMusic()
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                guard let self else{ return }
                if self.musicIndex == (self.allMusic.count - 1) {
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
        if musicIndex < (allMusic.count - 1) {
            player?.pause()
            musicIndex += 1
            loadMusic()
            play()
        }
    }
    
    func loadMusic() {
        musicURL = URL(string: allMusic[musicIndex])
        playerItem = AVPlayerItem(url: musicURL!)
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
}
