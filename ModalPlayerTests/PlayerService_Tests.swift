//
//  PlayerService_Tests.swift
//  ModalPlayerTests
//
//  Created by Danjuma Nasiru on 26/10/2023.
//

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
    
    func testRewindAction() throws {
        let sut = PlayerService()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIsPlaying, false)
    }
    
    func testRewindAction_musicIndexIsZero() throws {
        let sut = PlayerService()
        
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 0)
    }
    
    func testRewindAction_musicStarted() {
        let sut = PlayerService()
        sut.musicTracks = [
            .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3"),
            .init(id: 2, artistName: "Artist 2", trackTitle: "Sample 2", trackURL: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
            .init(id: 3, artistName: "Artist 3", trackTitle: "Sample 3", trackURL: "https://download.samplelib.com/mp3/sample-9s.mp3")
        ]
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIsPlaying, true)
        XCTAssertEqual(sut.musicIndex, 0)
        
    }
    
    func testRewindAction_musicStartedthenPaused() {
        let sut = PlayerService()
        sut.musicTracks = [
            .init(id: 1, artistName: "Artist 1", trackTitle: "Sample 1", trackURL: "https://samples-files.com/samples/Audio/mp3/sample-file-4.mp3"),
            .init(id: 2, artistName: "Artist 2", trackTitle: "Sample 2", trackURL: "https://mp3bob.ru/download/muz/Rum-pum-pum.mp3"),
            .init(id: 3, artistName: "Artist 3", trackTitle: "Sample 3", trackURL: "https://download.samplelib.com/mp3/sample-9s.mp3")
        ]
        sut.startAudio(track: sut.musicTracks[sut.musicIndex])
        sut.pause()
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIsPlaying, false)
        XCTAssertEqual(sut.musicIndex, 0)
        
    }
    
    func testRewindAction_4() {
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
    
    func testRewindAction_5() {
        let sut = PlayerService()
        
        sut.musicTracks = []
        sut.pause()
        sut.nextMusic()
                
        sut.rewindAction()
        
        XCTAssertEqual(sut.musicIndex, 0)
        XCTAssertEqual(sut.musicTracks, [])
        XCTAssertEqual(sut.musicIsPlaying, false)
    }
    
    func testPerformanceExample() throws {
        
    }
    
}
