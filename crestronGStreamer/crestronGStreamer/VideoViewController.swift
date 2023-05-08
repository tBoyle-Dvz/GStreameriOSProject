//
//  VideoViewController.swift
//  crestronGStreamer
//
//  Created by Tim Boyle on 5/6/23.
//

import UIKit

class VideoViewController: UIViewController {
    
    // MARK: members
    let model : VideoViewModel = VideoViewModel()

    // UI elements linked to storyboard
    @IBOutlet var viewVideoContainer : UIView!
    @IBOutlet var viewVideo : UIView!
    @IBOutlet var labelMessage : UILabel!
    @IBOutlet var buttonPlay : UIBarButtonItem!
    @IBOutlet var buttonStop : UIBarButtonItem!
    @IBOutlet var constraintVideoWidth : NSLayoutConstraint!
    @IBOutlet var constraintVideoHeight : NSLayoutConstraint!
    
    
    // MARK: view controller lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize GStreamer. The video will auto-play once the player is initialized
        GStreamerService.initGStreamerLibraryForiOS() // one time init
        model.prepareGStreamer(self, videoView: viewVideo)
        
        // Disable buttons until video is ready
        self.refreshPlayerControlsState("Initializing, please wait...")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // stop video and clean up if haven't already
        model.releaseGStreamer()
    }
    
    override func viewDidLayoutSubviews() {
        // Directly set layout constraints to enforce video dimensions
        
        let view_width = viewVideoContainer.bounds.size.width
        let view_height = viewVideoContainer.bounds.size.height

        let correct_height = view_width * model.media_height / model.media_width
        let correct_width = view_height * model.media_width / model.media_height

        if (correct_height < view_height) {
            constraintVideoHeight.constant = correct_height
            constraintVideoWidth.constant = view_width
        } else {
            constraintVideoWidth.constant = correct_width
            constraintVideoHeight.constant = view_height
        }
    }
    
    
    // MARK: ui event handlers
    @IBAction func handleButtonTapPlay() {
        self.model.prepareGStreamer(self, videoView: viewVideo)
        self.refreshPlayerControlsState("Initializing...")
    }
    
    @IBAction func handleButtonTapStop() {
        self.finishPlayingVideo("Thanks for watching");
    }
    
    
    // MARK: ui support methods
    func finishPlayingVideo(_ statusMessage:String) {
        self.model.releaseGStreamer()
        self.refreshPlayerControlsState(statusMessage)
    }
    
    func refreshPlayerControlsState(_ statusMessage:String) {
        switch self.model.getPlayerState() {
        case .notReady:
            buttonPlay.isEnabled = true
            buttonStop.isEnabled = false
        case .initializing:
            buttonPlay.isEnabled = false
            buttonStop.isEnabled = false
        case .playing:
            buttonPlay.isEnabled = false
            buttonStop.isEnabled = true
        }
        // This label is just for demo purposes. It could be evolved into some better status UI
        self.labelMessage.text = statusMessage
    }
}

// MARK: GStreamerServiceDelegate protocol
extension VideoViewController: GStreamerServiceDelegate
{
    func gstreamerInitialized()
    {
        DispatchQueue.main.async { [self] in
            // Auto start the video for now.
            // An alternative would be add a "ready" state and let user tap play.
            self.model.playVideo()
            self.refreshPlayerControlsState("Playing video...")
        }
    }
    
    func gstreamerError(_ message:String)
    {
        DispatchQueue.main.async { [self] in
            // Better error handling should be implemented
            print("GStreamerError: " + message)
            self.finishPlayingVideo("Sorry, an error occured");
        }
    }

    func gstreamerSetUIMessage(_ message:String)
    {
        DispatchQueue.main.async { //[self] in
            //self.labelMessage.text = message
            // these messages were confusing in the UI, so print to console instead
            print("GStreamerUIMessage: " + message)
        }
    }
     
    func gstreamerEndOfStream() {
        DispatchQueue.main.async { [self] in
            // For now, we do the same as the Stop button.
            self.finishPlayingVideo("Thanks for watching...");
        }
    }
    
    func gstreamerMediaSizeChanged(_ width:Int, height:Int)
    {
        // Refresh UI on main thread
        DispatchQueue.main.async { [self] in
            // The math later relies on floats, so convert here.
            self.model.updateMediaSize(width: CGFloat(integerLiteral: width),
                                       height: CGFloat(integerLiteral: height))
            
            self.viewDidLayoutSubviews();
            self.viewVideo.setNeedsLayout();
            self.viewVideo.layoutIfNeeded();
        }
    }
}

