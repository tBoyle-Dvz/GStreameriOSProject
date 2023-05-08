#import <Foundation/Foundation.h>

// TjB: this class is largely based on GStreamerBackendDelegate from the GStreamer tutorials
//      a couple of additional callbacks were added.

@protocol GStreamerServiceDelegate <NSObject>

@optional
/* Called when the GStreamerService has finished initializing
 * and is ready to accept orders. */
-(void) gstreamerInitialized;

/* For now this sends a string for the purposes of this demo project. But error codes would be better */
-(void) gstreamerError:(NSString*)message;

/* Called when the GStreamerService wants to output some message to the screen.
   Errors come through gstreamerError   */
-(void) gstreamerSetUIMessage:(NSString *)message;

/* Called when the media size is first discovered or it changes */
-(void) gstreamerMediaSizeChanged:(NSInteger)width height:(NSInteger)height;

/* Called when playing media finished */
-(void) gstreamerEndOfStream;


@end
