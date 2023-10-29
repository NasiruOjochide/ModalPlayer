//
//  PlayerService_Tests.swift
//  ModalPlayerTests
//
//  Created by Danjuma Nasiru on 26/10/2023.
//

import Combine
import XCTest
@testable import ModalPlayer

final class PlayerService_Tests: XCTestCase {
    
    let trackListToTest: [TrackModel] = [
        .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3"),
        .init(id: 2, artistName: "Artist 2", trackTitle: "Sample 2", trackURL: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
        .init(id: 3, artistName: "Artist 3", trackTitle: "Sample 3", trackURL: "https://download.samplelib.com/mp3/sample-9s.mp3")
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_RewindAction() throws {
        
        let sut = PlayerService()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIsPlaying, false)
    }
    
    func test_RewindAction_musicIndexIsZero() throws {
        
        let sut = PlayerService()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func test_RewindAction_musicStarted() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIsPlaying, true)
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func test_RewindAction_musicStartedthenPaused() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.pause()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIsPlaying, false)
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func test_RewindAction_4() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: trackListToTest[0])
        sut.pause()
        sut.nextMusic()
        sut.musicTracks = []
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 1)
        XCTAssertEqual(sut.musicTracks, [])
        XCTAssertEqual(sut.musicIsPlaying, true)
    }
    
    func test_RewindAction_5() {
        
        let sut = PlayerService()
        sut.musicTracks = []
        sut.pause()
        sut.nextMusic()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertEqual(sut.musicTracks, [])
        XCTAssertEqual(sut.musicIsPlaying, false)
    }
    
    func test_RewindAction_6() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.nextMusic()
        sut.pause()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.currentTrack, trackListToTest[0])
        XCTAssertFalse(sut.musicIsPlaying)
    }
    
    func test_RewindOnMusicPaused() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.musicIsPlaying = false
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertNil(sut.currentTrack)
    }
    
    func test_RewindOnMusicPaused_1() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: trackListToTest[0])
        sut.pause()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertEqual(sut.currentTrack, trackListToTest[0])
    }
    
    func test_RewindOnMusicPaused_2() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: trackListToTest[0])
        sut.nextMusic()
        sut.nextMusic()
        sut.musicIsPlaying = false
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 1)
        XCTAssertEqual(sut.currentTrack, trackListToTest[1])
    }
    
    func test_RewindOnMusicPlaying() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.musicIsPlaying = true
        
        sut.rewindAction()
        
        XCTAssertNil(sut.currentTrack)
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func test_RewindOnMusicPlaying_1() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: trackListToTest[1])
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.currentTrack, trackListToTest[1])
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func test_RewindOnMusicPlaying_2() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: trackListToTest[1])
        sut.musicIndex = 1
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.currentTrack, trackListToTest[0])
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertTrue(sut.musicIsPlaying)
    }
    
    func test_NextMusic() {
        
        let sut = PlayerService()
        
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicTracks, [])
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertEqual(sut.currentTrack, nil)
    }
    
    func test_NextMusic_1() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicTracks, trackListToTest)
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertEqual(sut.currentTrack, nil)
    }
    
    func test_NextMusis_2() {
        
        let sut = PlayerService()
        sut.startAudio(track: trackListToTest[0])
        
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func test_NextMusis_3() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[0])
        
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicIndex, 1)
    }
    
    func test_NextMusic_4() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.musicIndex = 3
        
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicIndex, 3)
        XCTAssertEqual(sut.currentTrack, trackListToTest[0])
    }
    
    func test_NextMusic_5() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.musicIndex = -1
        
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicIndex, -1)
        XCTAssertEqual(sut.currentTrack, trackListToTest[0])
    }
    
    func test_NextMusic_6() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.nextMusic()
        sut.musicIndex = -1
        sut.musicTracks = []
        sut.nextMusic()
        
        XCTAssertEqual(sut.currentTrack, trackListToTest[1])
        XCTAssertEqual(sut.musicIndex, -1)
        XCTAssertEqual(sut.musicTracks, [])
    }
    
    func test_NextMusic_7() {
        
        let sut = PlayerService()
        sut.musicTracks = trackListToTest
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.nextMusic()
        sut.pause()
        sut.rewindAction()
        sut.nextMusic()
        sut.pause()
        sut.nextMusic()
        
        XCTAssertEqual(sut.musicIndex, 2)
        XCTAssertEqual(sut.currentTrack, trackListToTest[2])
        XCTAssertEqual(sut.musicIsPlaying, true)
    }
    
    func test_LoadMusic() {
        
        let sut = PlayerService()
        var cancellable = Set<AnyCancellable>()
        var publisherValue: Double = 1
        sut.musicProgressPublisher
            .sink(receiveValue: {
                publisherValue = $0
            })
            .store(in: &cancellable)
        sut.startAudio(track: trackListToTest[0])
        
        XCTAssertEqual(sut.currentTrack, trackListToTest[0])
        XCTAssertEqual(publisherValue, 0)
    }
    
    func test_Play() {
        
        let sut = PlayerService()
        
        sut.play()
        
        XCTAssertFalse(sut.musicIsPlaying)
    }
    
    func test_Play_1() {
        
        let sut = PlayerService()
        sut.startAudio(track: trackListToTest[0])
        sut.pause()
        
        sut.play()
        
        XCTAssertTrue(sut.musicIsPlaying)
    }
    
    func test_Pause() {
        
        let sut = PlayerService()
        
        sut.pause()
        
        XCTAssertFalse(sut.musicIsPlaying)
    }
    
    func test_Pause_1() {
        
        let sut = PlayerService()
        sut.startAudio(track: trackListToTest[0])
        
        sut.pause()
        
        XCTAssertFalse(sut.musicIsPlaying)
    }
    
    func test_StartAudio() {
        
        let sut = PlayerService()
        
        sut.startAudio(track: trackListToTest[0])
        
        XCTAssertNotNil(sut.currentTrack)
        XCTAssertTrue(sut.musicIsPlaying)
    }
    
    func testPerformanceExample() throws {
        
    }
    
}
