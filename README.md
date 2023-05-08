# GStreameriOSProject
Sample project integrating GStreamer into a Swift iOS app

Overview:
- GStreamerService contains a few Objective C classes that wrap the GStreamer framework for iOS
- GStreamerServiceDelegate is the callback protocol to connect the UI to GStreamer events
- VideoViewController and VideoViewModel are Swift classes that handle the UI
- Main.storyboard contains the simple UI for VideoViewController. (I often avoid storyboard in favor of programmatically creating the UI in Swift code. But, I used storyboard here in case that was expected.)
- The storyboard makes use of some Size Class/dynamic layout support to tweak the looks on iPad/larger devices. But I didn't spend a lot of time on this.

Warnings:
- The primary remaining warning is about CAEAGLLayer being deprecated. I am not sure if there a solution for that. It seems GStreamer needs it for OpenGL. I would need to investigate more on that.
- I surpressed some other warnings with the GST framework. I would take some time to drill down on those if this was a real project.

Issues and next steps:
- Tests: I would implement tests to use the ViewModel outside of the ViewController. This would help flush out issues. I would also add functionality to GStreamerService skip to the end of the video to test endOfStream handling. 
- I would need to investigate further if the current stop video handling is truly graceful. I think I would need to get deeper into the GStreamer framework and possibly add to the GStreamerService functionality.
- Playing a video after stopping the playback crashes at the moment. I would need more time to investigate what is causing the crash. This wasn't really part of the project ask, so I didn't want to spend too much time on this. It's possiblly related to the stop/deinit of the GStreamerService. This report sounds like it could possibly be the same issue: https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/2381
