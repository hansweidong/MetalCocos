/****************************************************************************
 Copyright (c) 2010-2012 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "platform/CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#import <UIKit/UIKit.h>

#include "CCEAGLView-ios.h"
#include "CCMetalView-ios.h"
#include "CCDirectorCaller-ios.h"
#include "CCGLViewImpl-ios.h"
#include "CCSet.h"
#include "base/CCTouch.h"

NS_CC_BEGIN

#if CC_PLATFORM_IOS_METAL
void* GLViewImpl::_pixelFormat = 0;
#else//CC_PLATFORM_IOS_METAL
void* GLViewImpl::_pixelFormat = kEAGLColorFormatRGB565;
#endif//CC_PLATFORM_IOS_METAL
int GLViewImpl::_depthFormat = GL_DEPTH_COMPONENT16;

GLViewImpl* GLViewImpl::createWithEAGLView(void *eaglview)
{
    auto ret = new (std::nothrow) GLViewImpl;
    if(ret && ret->initWithEAGLView(eaglview)) {
        ret->autorelease();
        return ret;
    }

    return nullptr;
}

GLViewImpl* GLViewImpl::create(const std::string& viewName)
{
    auto ret = new (std::nothrow) GLViewImpl;
    if(ret && ret->initWithFullScreen(viewName)) {
        ret->autorelease();
        return ret;
    }

    return nullptr;
}

GLViewImpl* GLViewImpl::createWithRect(const std::string& viewName, Rect rect, float frameZoomFactor)
{
    auto ret = new (std::nothrow) GLViewImpl;
    if(ret && ret->initWithRect(viewName, rect, frameZoomFactor)) {
        ret->autorelease();
        return ret;
    }

    return nullptr;
}

GLViewImpl* GLViewImpl::createWithFullScreen(const std::string& viewName)
{
    auto ret = new (std::nothrow) GLViewImpl();
    if(ret && ret->initWithFullScreen(viewName)) {
        ret->autorelease();
        return ret;
    }

    return nullptr;
}

void GLViewImpl::convertAttrs()
{
#if CC_PLATFORM_IOS_METAL
#else//CC_PLATFORM_IOS_METAL
    if(_glContextAttrs.redBits==8 && _glContextAttrs.greenBits==8 && _glContextAttrs.blueBits==8 && _glContextAttrs.alphaBits==8)
    {
        _pixelFormat = kEAGLColorFormatRGBA8;
    }
    if(_glContextAttrs.depthBits==24 && _glContextAttrs.stencilBits==8)
    {
        _depthFormat = GL_DEPTH24_STENCIL8_OES;
    }
#endif//CC_PLATFORM_IOS_METAL
}

GLViewImpl::GLViewImpl()
{
}

GLViewImpl::~GLViewImpl()
{
    //CCEAGLView *glview = (CCEAGLView*) _eaglview;
    //[glview release];
}

bool GLViewImpl::initWithEAGLView(void *eaglview)
{
    _eaglview = eaglview;
#if CC_PLATFORM_IOS_GL
    CCEAGLView *glview = (CCEAGLView*) _eaglview;
#else
    CCMetalView *glview = (CCMetalView*) _eaglview;
#endif

    _screenSize.width = _designResolutionSize.width = [glview getWidth];
    _screenSize.height = _designResolutionSize.height = [glview getHeight];
//    _scaleX = _scaleY = [glview contentScaleFactor];

    return true;
}

bool GLViewImpl::initWithRect(const std::string& viewName, Rect rect, float frameZoomFactor)
{
    CGRect r = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    convertAttrs();
#if CC_PLATFORM_IOS_GL
    CCEAGLView *eaglview = [CCEAGLView viewWithFrame: r
                                       pixelFormat: (NSString*)_pixelFormat
                                       depthFormat: _depthFormat
                                preserveBackbuffer: NO
                                        sharegroup: nil
                                     multiSampling: NO
                                   numberOfSamples: 0];
#else
    CCMetalView *eaglview = [CCMetalView viewWithFrame: r
                                         pixelFormat: (NSString*)_pixelFormat
                                         depthFormat: _depthFormat
                                  preserveBackbuffer: NO
                                       multiSampling: NO
                                     numberOfSamples: 0];
#endif
    
    [eaglview setMultipleTouchEnabled:YES];

    _screenSize.width = _designResolutionSize.width = [eaglview getWidth];
    _screenSize.height = _designResolutionSize.height = [eaglview getHeight];
//    _scaleX = _scaleY = [eaglview contentScaleFactor];

    _eaglview = eaglview;

    return true;
}

bool GLViewImpl::initWithFullScreen(const std::string& viewName)
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    Rect r;
    r.origin.x = rect.origin.x;
    r.origin.y = rect.origin.y;
    r.size.width = rect.size.width;
    r.size.height = rect.size.height;

    return initWithRect(viewName, r, 1);
}

bool GLViewImpl::isOpenGLReady()
{
    return _eaglview != nullptr;
}

bool GLViewImpl::setContentScaleFactor(float contentScaleFactor)
{
    CC_ASSERT(_resolutionPolicy == ResolutionPolicy::UNKNOWN); // cannot enable retina mode
    _scaleX = _scaleY = contentScaleFactor;
#if CC_PLATFORM_IOS_GL
    CCEAGLView *eaglview = (CCEAGLView*) _eaglview;
#else
    CCMetalView *eaglview = (CCMetalView*) _eaglview;
#endif
    [eaglview setNeedsLayout];

    return true;
}

float GLViewImpl::getContentScaleFactor() const
{
#if CC_PLATFORM_IOS_GL
    CCEAGLView *eaglview = (CCEAGLView*) _eaglview;
#else
    CCMetalView *eaglview = (CCMetalView*) _eaglview;
#endif

    float scaleFactor = [eaglview contentScaleFactor];

//    CCASSERT(scaleFactor == _scaleX == _scaleY, "Logic error in GLView::getContentScaleFactor");

    return scaleFactor;
}

void GLViewImpl::end()
{
    [CCDirectorCaller destroy];
    
    // destroy EAGLView
#if CC_PLATFORM_IOS_GL
    CCEAGLView *eaglview = (CCEAGLView*) _eaglview;
#else
    CCMetalView *eaglview = (CCMetalView*) _eaglview;
#endif

    [eaglview removeFromSuperview];
    //[eaglview release];
}


void GLViewImpl::swapBuffers()
{
#if CC_PLATFORM_IOS_GL
    CCEAGLView *eaglview = (CCEAGLView*) _eaglview;
#else
    CCMetalView *eaglview = (CCMetalView*) _eaglview;
#endif
    [eaglview swapBuffers];
}

void GLViewImpl::setIMEKeyboardState(bool open)
{
#if CC_PLATFORM_IOS_GL
    CCEAGLView *eaglview = (CCEAGLView*) _eaglview;
#else
    CCMetalView *eaglview = (CCMetalView*) _eaglview;
#endif

    if (open)
    {
        [eaglview becomeFirstResponder];
    }
    else
    {
        [eaglview resignFirstResponder];
    }
}

NS_CC_END

#endif // CC_PLATFOR_IOS

