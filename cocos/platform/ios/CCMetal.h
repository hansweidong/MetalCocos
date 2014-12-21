#if 0
#import <Metal/Metal.h>

@interface CCMetal

@property (nonatomic, readonly) id <MTLDevice> device;
@property (nonatomic, readonly) id <MTLDevice> device;


// load all assets before triggering rendering
- (void)configure:(AAPLView *)view;

- (void)cleanup;

@end
#endif