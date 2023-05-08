//
//  VideoViewModel.swift
//  crestronGStreamer
//
//  Created by Tim Boyle on 5/7/23.
//

import Foundation

// NOTE: it might be better to query the state of the GStreamerService,
// but for now, I'm using this enum and tracking the state from the UI layer.
// If we use the service state, this enum could be used simplify those states for the UI layer.
// I would add a .ready state if we didn't autoplay the video after initialization
enum VideoPlayerState: UInt32 {
    case notReady
    case initializing
    case playing
}


class VideoViewModel : NSObject {
    
    // MARK: data
    // fixed for now, but could be dynamic
    let uriVideo: String = "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4"
    
    // initial values, might be updated later
    var media_width : CGFloat = 320.0
    var media_height : CGFloat = 240.0
    
    // MARK: internal data
    private var gst_service: GStreamerService?
    private var playerState : VideoPlayerState = .notReady
    
    
    // MARK: init
    override init() {
    }
    
    // MARK: support methods
    func getPlayerState() -> VideoPlayerState {
        // In the future, there could be more states or we could check state of Backend here
        return self.playerState
    }
    
    
    // MARK: state changes from UI
    func prepareGStreamer(_ delegate: GStreamerServiceDelegate, videoView: UIView) {
        if ( self.playerState == .notReady ) {
            // Initialize GStreamer. ViewController will get callbacks for now.
            self.gst_service = GStreamerService.init(delegate, videoView: videoView)
            self.playerState = .initializing
        }
        else {
            assertionFailure("Unexpected state")
        }
    }
    
    func releaseGStreamer() {
        
        if let service = self.gst_service {
            if ( self.playerState == .playing ) {
                service.pause()
            }
            
            service.deinit()
        }
        self.gst_service = nil
        self.playerState = .notReady
    }
    
    func playVideo() {
        //--if self.playerState == .ready, let backend = self.gst_backend {
        if self.playerState == .initializing, let service = self.gst_service {
            service.setUri(self.uriVideo)
            service.play()
            self.playerState = .playing
        }
        else {
            assertionFailure("Unexpected state")
        }
    }
    
    func updateMediaSize(width: CGFloat, height: CGFloat) {
        self.media_width = width
        self.media_height = height
    }
    
}
