
#include "platform/CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#if CC_PLATFORM_IOS_METAL

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

//CLASS INTERFACE:

/** CCEAGLView Class.
 * This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 * The view content is basically an EAGL surface you render your OpenGL scene into.
 * Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
 */
@interface CCMetalView : UIView <UIKeyInput, UITextInput>
{

    NSString                *pixelformat_;
    GLuint                    depthFormat_;
    BOOL                    preserveBackbuffer_;

    CGSize                    size_;
    BOOL                    discardFramebufferSupported_;

    //fsaa addition
    BOOL                    multisampling_;
    unsigned int               requestedSamples_;
    BOOL                    isUseUITextField;
@private
    NSString *              markedText_;
    CGRect                  caretRect_;
    CGRect                  originalRect_;
    NSNotification*         keyboardShowNotification_;
    BOOL                    isKeyboardShown_;
}

@property(nonatomic, readonly) UITextPosition *beginningOfDocument;
@property(nonatomic, readonly) UITextPosition *endOfDocument;
@property(nonatomic, assign) id<UITextInputDelegate> inputDelegate;
@property(nonatomic, readonly) UITextRange *markedTextRange;
@property (nonatomic, copy) NSDictionary *markedTextStyle;
@property(readwrite, copy) UITextRange *selectedTextRange;
@property(nonatomic, readonly) id<UITextInputTokenizer> tokenizer;
@property(nonatomic, readonly, getter = isKeyboardShown) BOOL isKeyboardShown;
@property(nonatomic, copy) NSNotification* keyboardShowNotification;
/** creates an initializes an CCEAGLView with a frame and 0-bit depth buffer, and a RGB565 color buffer */
+ (id) viewWithFrame:(CGRect)frame;
/** creates an initializes an CCEAGLView with a frame, a color buffer format, and 0-bit depth buffer */
+ (id) viewWithFrame:(CGRect)frame pixelFormat:(NSString*)format;
/** creates an initializes an CCEAGLView with a frame, a color buffer format, and a depth buffer format */
+ (id) viewWithFrame:(CGRect)frame pixelFormat:(NSString*)format depthFormat:(GLuint)depth;
/** creates an initializes an CCEAGLView with a frame, a color buffer format, a depth buffer format, a sharegroup, and multisamping */
+ (id) viewWithFrame:(CGRect)frame pixelFormat:(NSString*)format depthFormat:(GLuint)depth preserveBackbuffer:(BOOL)retained multiSampling:(BOOL)multisampling numberOfSamples:(unsigned int)samples;

/** Initializes an CCEAGLView with a frame and 0-bit depth buffer, and a RGB565 color buffer */
- (id) initWithFrame:(CGRect)frame; //These also set the current context
/** Initializes an CCEAGLView with a frame, a color buffer format, and 0-bit depth buffer */
- (id) initWithFrame:(CGRect)frame pixelFormat:(NSString*)format;
/** Initializes an CCEAGLView with a frame, a color buffer format, a depth buffer format, a sharegroup and multisampling support */
- (id) initWithFrame:(CGRect)frame pixelFormat:(NSString*)format depthFormat:(GLuint)depth preserveBackbuffer:(BOOL)retained multiSampling:(BOOL)sampling numberOfSamples:(unsigned int)nSamples;


/** pixel format: it could be RGBA8 (32-bit) or RGB565 (16-bit) */
@property(nonatomic,readonly) NSString* pixelFormat;
/** depth format of the render buffer: 0, 16 or 24 bits*/
@property(nonatomic,readonly) GLuint depthFormat;

/** returns surface size in pixels */
@property(nonatomic,readonly) CGSize surfaceSize;

@property(nonatomic,readwrite) BOOL multiSampling;


/** CCEAGLView uses double-buffer. This method swaps the buffers */
-(void) swapBuffers;

- (CGRect) convertRectFromViewToSurface:(CGRect)rect;
- (CGPoint) convertPointFromViewToSurface:(CGPoint)point;

-(int) getWidth;
-(int) getHeight;

-(void) doAnimationWhenKeyboardMoveWithDuration:(float) duration distance:(float) dis;
-(void) doAnimationWhenAnotherEditBeClicked;
@end

#endif //CC_PLATFORM_IOS_METAL
#endif // CC_PLATFORM_IOS
