#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GStreamerServiceDelegate.h"

// TjB: this class is largely based on GStreamerBackend from the GStreamer tutorials
//      It's primarily Tutorial 3 level functionality with some things added from
//      later tutorials. There a few additions and tweaks that I made. Those should
//      be labeled with // TjB: comments

@interface GStreamerService : NSObject

// Static initializer for iOS platform plugins
+(void)initGStreamerLibraryForiOS;

/* Initialization method. Pass the delegate that will take care of the UI.
 * This delegate must implement the GStreamerServiceDelegate protocol.
 * Pass also the UIView object that will hold the video window. */
-(id) init:(id) uiDelegate videoView:(UIView*) video_view;

/* Quit the main loop and free all resources, including the pipeline and
 * the references to the ui delegate and the UIView used for rendering, so
 * these objects can be deallocated. */
-(void) deinit;

/* Set the pipeline to PLAYING */
-(void) play;

/* Set the pipeline to PAUSED */
-(void) pause;

/* Set the URI to be played */
-(void) setUri:(NSString*)uri;

@end
