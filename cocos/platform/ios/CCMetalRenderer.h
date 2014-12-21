#if 0

#include "platform/CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#if CC_PLATFORM_IOS_METAL

#import "CCMetalView-ios.h"
#import <Metal/Metal.h>

//@interface CCMetalRenderer : NSObject <AAPLViewControllerDelegate, AAPLViewDelegate>
@interface CCMetalRenderer : NSObject

// renderer will create a default device at init time.
@property (nonatomic, readonly) id <MTLDevice> device;

// this value will cycle from 0 to g_max_inflight_buffers whenever a display completes ensuring renderer clients
// can synchronize between g_max_inflight_buffers count buffers, and thus avoiding a constant buffer from being overwritten between draws
@property (nonatomic, readonly) NSUInteger constantDataBufferIndex;

//  These queries exist so the View can initialize a framebuffer that matches the expectations of the renderer
@property (nonatomic, readonly) MTLPixelFormat depthPixelFormat;
@property (nonatomic, readonly) MTLPixelFormat stencilPixelFormat;
@property (nonatomic, readonly) NSUInteger sampleCount;

// load all assets before triggering rendering
- (void)configure:(CCMetalView *)view;

@end

#endif//if CC_PLATFORM_IOS_METAL
#endif // CC_PLATFORM_IOS

#endif