
/*
* Support for RGBA_4_4_4_4 and RGBA_5_5_5_1 was copied from:
* https://devforums.apple.com/message/37855#37855 by a1studmuffin
*/

#include "renderer/CCTexture2D.h"

#if CC_PLATFORM_IOS_METAL

#import <Metal/Metal.h>
#import <simd/simd.h>

#include "platform/CCGL.h"
#include "platform/CCImage.h"
#include "base/ccUtils.h"
#include "platform/CCDevice.h"
#include "base/ccConfig.h"
#include "base/ccMacros.h"
#include "base/CCConfiguration.h"
#include "platform/CCPlatformMacros.h"
#include "base/CCDirector.h"
#include "renderer/CCGLProgram.h"
#include "renderer/ccGLStateCache.h"
#include "renderer/CCGLProgramCache.h"

#include "deprecated/CCString.h"


#if CC_ENABLE_CACHE_TEXTURE_DATA
    #include "renderer/CCTextureCache.h"
#endif

#include "CCMetalView-ios.h"

NS_CC_BEGIN


namespace {
    typedef Texture2D::PixelFormatInfoMap::value_type PixelFormatInfoMapValue;
    static const PixelFormatInfoMapValue TexturePixelFormatInfoTablesValue[] =
    {
        PixelFormatInfoMapValue(Texture2D::PixelFormat::BGRA8888, Texture2D::PixelFormatInfo(GL_BGRA, GL_BGRA, GL_UNSIGNED_BYTE, 32, false, true)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::RGBA8888, Texture2D::PixelFormatInfo(GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE, 32, false, true)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::RGBA4444, Texture2D::PixelFormatInfo(GL_RGBA, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, 16, false, true)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::RGB5A1, Texture2D::PixelFormatInfo(GL_RGBA, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, 16, false, true)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::RGB565, Texture2D::PixelFormatInfo(GL_RGB, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, 16, false, false)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::RGB888, Texture2D::PixelFormatInfo(GL_RGB, GL_RGB, GL_UNSIGNED_BYTE, 24, false, false)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::A8, Texture2D::PixelFormatInfo(GL_ALPHA, GL_ALPHA, GL_UNSIGNED_BYTE, 8, false, false)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::I8, Texture2D::PixelFormatInfo(GL_LUMINANCE, GL_LUMINANCE, GL_UNSIGNED_BYTE, 8, false, false)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::AI88, Texture2D::PixelFormatInfo(GL_LUMINANCE_ALPHA, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 16, false, true)),
        
#ifdef GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG
        PixelFormatInfoMapValue(Texture2D::PixelFormat::PVRTC2, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG, 0xFFFFFFFF, 0xFFFFFFFF, 2, true, false)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::PVRTC2A, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG, 0xFFFFFFFF, 0xFFFFFFFF, 2, true, true)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::PVRTC4, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, 0xFFFFFFFF, 0xFFFFFFFF, 4, true, false)),
        PixelFormatInfoMapValue(Texture2D::PixelFormat::PVRTC4A, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, 0xFFFFFFFF, 0xFFFFFFFF, 4, true, true)),
#endif
        
#ifdef GL_ETC1_RGB8_OES
        PixelFormatInfoMapValue(Texture2D::PixelFormat::ETC, Texture2D::PixelFormatInfo(GL_ETC1_RGB8_OES, 0xFFFFFFFF, 0xFFFFFFFF, 4, true, false)),
#endif
        
#ifdef GL_COMPRESSED_RGBA_S3TC_DXT1_EXT
        PixelFormatInfoMapValue(Texture2D::PixelFormat::S3TC_DXT1, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGBA_S3TC_DXT1_EXT, 0xFFFFFFFF, 0xFFFFFFFF, 4, true, false)),
#endif
        
#ifdef GL_COMPRESSED_RGBA_S3TC_DXT3_EXT
        PixelFormatInfoMapValue(Texture2D::PixelFormat::S3TC_DXT3, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGBA_S3TC_DXT3_EXT, 0xFFFFFFFF, 0xFFFFFFFF, 8, true, false)),
#endif
        
#ifdef GL_COMPRESSED_RGBA_S3TC_DXT5_EXT
        PixelFormatInfoMapValue(Texture2D::PixelFormat::S3TC_DXT5, Texture2D::PixelFormatInfo(GL_COMPRESSED_RGBA_S3TC_DXT5_EXT, 0xFFFFFFFF, 0xFFFFFFFF, 8, true, false)),
#endif
        
#ifdef GL_ATC_RGB_AMD
        PixelFormatInfoMapValue(Texture2D::PixelFormat::ATC_RGB, Texture2D::PixelFormatInfo(GL_ATC_RGB_AMD,
                                                                                            0xFFFFFFFF, 0xFFFFFFFF, 4, true, false)),
#endif
        
#ifdef GL_ATC_RGBA_EXPLICIT_ALPHA_AMD
        PixelFormatInfoMapValue(Texture2D::PixelFormat::ATC_EXPLICIT_ALPHA, Texture2D::PixelFormatInfo(GL_ATC_RGBA_EXPLICIT_ALPHA_AMD,
                                                                                                       0xFFFFFFFF, 0xFFFFFFFF, 8, true, false)),
#endif
        
#ifdef GL_ATC_RGBA_INTERPOLATED_ALPHA_AMD
        PixelFormatInfoMapValue(Texture2D::PixelFormat::ATC_INTERPOLATED_ALPHA, Texture2D::PixelFormatInfo(GL_ATC_RGBA_INTERPOLATED_ALPHA_AMD,
                                                                                                           0xFFFFFFFF, 0xFFFFFFFF, 8, true, false)),
#endif
    };
    
    
    std::unordered_map<uint32_t, Texture2D*> textureInstanceMap;
}

Texture2D* Texture2D::retriveTexture(GLuint name) {
    if(textureInstanceMap.find(name)!=textureInstanceMap.end()){
        return textureInstanceMap[name];
    }
    return nullptr;
}

//The PixpelFormat corresponding information
const Texture2D::PixelFormatInfoMap Texture2D::_pixelFormatInfoTables(TexturePixelFormatInfoTablesValue,
                                                                      TexturePixelFormatInfoTablesValue + sizeof(TexturePixelFormatInfoTablesValue) / sizeof(TexturePixelFormatInfoTablesValue[0]));

// If the image has alpha, you can create RGBA8 (32-bit) or RGBA4 (16-bit) or RGB5A1 (16-bit)
// Default is: RGBA8888 (32-bit textures)
static Texture2D::PixelFormat g_defaultAlphaPixelFormat = Texture2D::PixelFormat::DEFAULT;

//////////////////////////////////////////////////////////////////////////
//conventer function

// IIIIIIII -> RRRRRRRRGGGGGGGGGBBBBBBBB
void Texture2D::convertI8ToRGB888(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i=0; i < dataLen; ++i)
    {
        *outData++ = data[i];     //R
        *outData++ = data[i];     //G
        *outData++ = data[i];     //B
    }
}

// IIIIIIIIAAAAAAAA -> RRRRRRRRGGGGGGGGBBBBBBBB
void Texture2D::convertAI88ToRGB888(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 1; i < l; i += 2)
    {
        *outData++ = data[i];     //R
        *outData++ = data[i];     //G
        *outData++ = data[i];     //B
    }
}

// IIIIIIII -> RRRRRRRRGGGGGGGGGBBBBBBBBAAAAAAAA
void Texture2D::convertI8ToRGBA8888(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0; i < dataLen; ++i)
    {
        *outData++ = data[i];     //R
        *outData++ = data[i];     //G
        *outData++ = data[i];     //B
        *outData++ = 0xFF;        //A
    }
}

// IIIIIIIIAAAAAAAA -> RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA
void Texture2D::convertAI88ToRGBA8888(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 1; i < l; i += 2)
    {
        *outData++ = data[i];     //R
        *outData++ = data[i];     //G
        *outData++ = data[i];     //B
        *outData++ = data[i + 1]; //A
    }
}

// IIIIIIII -> RRRRRGGGGGGBBBBB
void Texture2D::convertI8ToRGB565(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (int i = 0; i < dataLen; ++i)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i] & 0x00FC) << 3         //G
        | (data[i] & 0x00F8) >> 3;        //B
    }
}

// IIIIIIIIAAAAAAAA -> RRRRRGGGGGGBBBBB
void Texture2D::convertAI88ToRGB565(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 1; i < l; i += 2)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i] & 0x00FC) << 3         //G
        | (data[i] & 0x00F8) >> 3;        //B
    }
}

// IIIIIIII -> RRRRGGGGBBBBAAAA
void Texture2D::convertI8ToRGBA4444(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0; i < dataLen; ++i)
    {
        *out16++ = (data[i] & 0x00F0) << 8    //R
        | (data[i] & 0x00F0) << 4             //G
        | (data[i] & 0x00F0)                  //B
        | 0x000F;                             //A
    }
}

// IIIIIIIIAAAAAAAA -> RRRRGGGGBBBBAAAA
void Texture2D::convertAI88ToRGBA4444(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 1; i < l; i += 2)
    {
        *out16++ = (data[i] & 0x00F0) << 8    //R
        | (data[i] & 0x00F0) << 4             //G
        | (data[i] & 0x00F0)                  //B
        | (data[i+1] & 0x00F0) >> 4;          //A
    }
}

// IIIIIIII -> RRRRRGGGGGBBBBBA
void Texture2D::convertI8ToRGB5A1(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (int i = 0; i < dataLen; ++i)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i] & 0x00F8) << 3         //G
        | (data[i] & 0x00F8) >> 2         //B
        | 0x0001;                         //A
    }
}

// IIIIIIIIAAAAAAAA -> RRRRRGGGGGBBBBBA
void Texture2D::convertAI88ToRGB5A1(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 1; i < l; i += 2)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i] & 0x00F8) << 3         //G
        | (data[i] & 0x00F8) >> 2         //B
        | (data[i + 1] & 0x0080) >> 7;    //A
    }
}

// IIIIIIII -> IIIIIIIIAAAAAAAA
void Texture2D::convertI8ToAI88(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0; i < dataLen; ++i)
    {
        *out16++ = 0xFF00     //A
        | data[i];            //I
    }
}

// IIIIIIIIAAAAAAAA -> AAAAAAAA
void Texture2D::convertAI88ToA8(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 1; i < dataLen; i += 2)
    {
        *outData++ = data[i]; //A
    }
}

// IIIIIIIIAAAAAAAA -> IIIIIIII
void Texture2D::convertAI88ToI8(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 1; i < l; i += 2)
    {
        *outData++ = data[i]; //R
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA
void Texture2D::convertRGB888ToRGBA8888(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 3)
    {
        *outData++ = data[i];         //R
        *outData++ = data[i + 1];     //G
        *outData++ = data[i + 2];     //B
        *outData++ = 0xFF;            //A
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA -> RRRRRRRRGGGGGGGGBBBBBBBB
void Texture2D::convertRGBA8888ToRGB888(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 3; i < l; i += 4)
    {
        *outData++ = data[i];         //R
        *outData++ = data[i + 1];     //G
        *outData++ = data[i + 2];     //B
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> RRRRRGGGGGGBBBBB
void Texture2D::convertRGB888ToRGB565(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 3)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i + 1] & 0x00FC) << 3     //G
        | (data[i + 2] & 0x00F8) >> 3;    //B
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA -> RRRRRGGGGGGBBBBB
void Texture2D::convertRGBA8888ToRGB565(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 3; i < l; i += 4)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i + 1] & 0x00FC) << 3     //G
        | (data[i + 2] & 0x00F8) >> 3;    //B
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> IIIIIIII
void Texture2D::convertRGB888ToI8(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 3)
    {
        *outData++ = (data[i] * 299 + data[i + 1] * 587 + data[i + 2] * 114 + 500) / 1000;  //I =  (R*299 + G*587 + B*114 + 500) / 1000
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA -> IIIIIIII
void Texture2D::convertRGBA8888ToI8(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 3; i < l; i += 4)
    {
        *outData++ = (data[i] * 299 + data[i + 1] * 587 + data[i + 2] * 114 + 500) / 1000;  //I =  (R*299 + G*587 + B*114 + 500) / 1000
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA -> AAAAAAAA
void Texture2D::convertRGBA8888ToA8(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen -3; i < l; i += 4)
    {
        *outData++ = data[i + 3]; //A
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> IIIIIIIIAAAAAAAA
void Texture2D::convertRGB888ToAI88(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 3)
    {
        *outData++ = (data[i] * 299 + data[i + 1] * 587 + data[i + 2] * 114 + 500) / 1000;  //I =  (R*299 + G*587 + B*114 + 500) / 1000
        *outData++ = 0xFF;
    }
}


// RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA -> IIIIIIIIAAAAAAAA
void Texture2D::convertRGBA8888ToAI88(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    for (ssize_t i = 0, l = dataLen - 3; i < l; i += 4)
    {
        *outData++ = (data[i] * 299 + data[i + 1] * 587 + data[i + 2] * 114 + 500) / 1000;  //I =  (R*299 + G*587 + B*114 + 500) / 1000
        *outData++ = data[i + 3];
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> RRRRGGGGBBBBAAAA
void Texture2D::convertRGB888ToRGBA4444(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 3)
    {
        *out16++ = ((data[i] & 0x00F0) << 8           //R
                    | (data[i + 1] & 0x00F0) << 4     //G
                    | (data[i + 2] & 0xF0)            //B
                    |  0x0F);                         //A
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA -> RRRRGGGGBBBBAAAA
void Texture2D::convertRGBA8888ToRGBA4444(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 3; i < l; i += 4)
    {
        *out16++ = (data[i] & 0x00F0) << 8    //R
        | (data[i + 1] & 0x00F0) << 4         //G
        | (data[i + 2] & 0xF0)                //B
        |  (data[i + 3] & 0xF0) >> 4;         //A
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> RRRRRGGGGGBBBBBA
void Texture2D::convertRGB888ToRGB5A1(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 3)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i + 1] & 0x00F8) << 3     //G
        | (data[i + 2] & 0x00F8) >> 2     //B
        |  0x01;                          //A
    }
}

// RRRRRRRRGGGGGGGGBBBBBBBB -> RRRRRGGGGGBBBBBA
void Texture2D::convertRGBA8888ToRGB5A1(const unsigned char* data, ssize_t dataLen, unsigned char* outData)
{
    unsigned short* out16 = (unsigned short*)outData;
    for (ssize_t i = 0, l = dataLen - 2; i < l; i += 4)
    {
        *out16++ = (data[i] & 0x00F8) << 8    //R
        | (data[i + 1] & 0x00F8) << 3     //G
        | (data[i + 2] & 0x00F8) >> 2     //B
        |  (data[i + 3] & 0x0080) >> 7;   //A
    }
}
// conventer function end
//////////////////////////////////////////////////////////////////////////

Texture2D::Texture2D()
: _pixelFormat(Texture2D::PixelFormat::DEFAULT)
, _pixelsWide(0)
, _pixelsHigh(0)
, _name(0)
, _maxS(0.0)
, _maxT(0.0)
, _hasPremultipliedAlpha(false)
, _hasMipmaps(false)
, _shaderProgram(nullptr)
, _antialiasEnabled(true)
{
}

Texture2D::~Texture2D()
{
#if CC_ENABLE_CACHE_TEXTURE_DATA
    VolatileTextureMgr::removeTexture(this);
#endif
    
    CCLOGINFO("deallocing Texture2D: %p - id=%u", this, _name);
    CC_SAFE_RELEASE(_shaderProgram);
    
    if(_name)
    {
        GL::deleteTexture(_name);
        
        auto it = textureInstanceMap.find(_name);
        if(it!=textureInstanceMap.end()) {
            textureInstanceMap.erase(it);
        }
    }
}

void Texture2D::releaseGLTexture()
{
    if(_name)
    {
        GL::deleteTexture(_name);
        
        auto it = textureInstanceMap.find(_name);
        if(it!=textureInstanceMap.end()) {
            textureInstanceMap.erase(it);
        }
    }
    _name = 0;
}


Texture2D::PixelFormat Texture2D::getPixelFormat() const
{
    return _pixelFormat;
}

int Texture2D::getPixelsWide() const
{
    return _pixelsWide;
}

int Texture2D::getPixelsHigh() const
{
    return _pixelsHigh;
}

GLuint Texture2D::getName() const
{
    return _name;
}

Size Texture2D::getContentSize() const
{
    Size ret;
    ret.width = _contentSize.width / CC_CONTENT_SCALE_FACTOR();
    ret.height = _contentSize.height / CC_CONTENT_SCALE_FACTOR();
    
    return ret;
}

const Size& Texture2D::getContentSizeInPixels()
{
    return _contentSize;
}

GLfloat Texture2D::getMaxS() const
{
    return _maxS;
}

void Texture2D::setMaxS(GLfloat maxS)
{
    _maxS = maxS;
}

GLfloat Texture2D::getMaxT() const
{
    return _maxT;
}

void Texture2D::setMaxT(GLfloat maxT)
{
    _maxT = maxT;
}

GLProgram* Texture2D::getGLProgram() const
{
    return _shaderProgram;
}

void Texture2D::setGLProgram(GLProgram* shaderProgram)
{
    CC_SAFE_RETAIN(shaderProgram);
    CC_SAFE_RELEASE(_shaderProgram);
    _shaderProgram = shaderProgram;
}

bool Texture2D::hasPremultipliedAlpha() const
{
    return _hasPremultipliedAlpha;
}

bool Texture2D::initWithData(const void *data, ssize_t dataLen, Texture2D::PixelFormat pixelFormat, int pixelsWide, int pixelsHigh, const cocos2d::Size &contentSize)
{
    CCASSERT(dataLen>0 && pixelsWide>0 && pixelsHigh>0, "Invalid size");
    
    //if data has no mipmaps, we will consider it has only one mipmap
    MipmapInfo mipmap;
    mipmap.address = (unsigned char*)data;
    mipmap.len = static_cast<int>(dataLen);
    return initWithMipmaps(&mipmap, 1, pixelFormat, pixelsWide, pixelsHigh);
}


bool Texture2D::initWithMipmaps(MipmapInfo* mipmaps, int mipmapsNum, Texture2D::PixelFormat pixelFormat, int pixelsWide, int pixelsHigh) {

    UInt32 bytePerPixel = 1;
    MTLPixelFormat mtlPixelFormat = MTLPixelFormatRGBA8Unorm;
    switch (pixelFormat) {
        case Texture2D::PixelFormat::RGBA8888:
            mtlPixelFormat = MTLPixelFormatRGBA8Unorm;
            bytePerPixel = 4;
            break;
        default:
            CC_ASSERT(false);
            break;
    }
    
    uint32_t width    = (uint32_t)pixelsWide;
    uint32_t height   = (uint32_t)pixelsHigh;
    
    auto pTexDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:mtlPixelFormat
                                                                       width:width
                                                                      height:height
                                                                   mipmapped:NO];
    
    auto device = (__bridge id<MTLDevice>)Director::getInstance()->getMetalDevice();
    _texture = (MTLTexture*)[device newTextureWithDescriptor:pTexDesc];
    
    //data 書き込み成功するかな
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    
    const void* data = (const void*)mipmaps[0].address;
    
    auto rowBytes = bytePerPixel * width;//DataLenをheightで割ってもいいのかもしれん
    [(id<MTLTexture>)_texture replaceRegion:region
                                mipmapLevel:0
                                  withBytes:data
                                bytesPerRow:rowBytes];
    
    static uint32_t texNameSrc = 0;
    _name = texNameSrc++;

    _contentSize = Size((float)pixelsWide, (float)pixelsHigh);
    _pixelsWide = pixelsWide;
    _pixelsHigh = pixelsHigh;
    _pixelFormat = pixelFormat;
    _maxS = 1;
    _maxT = 1;

    _hasPremultipliedAlpha = false;
    _hasMipmaps = mipmapsNum > 1;

    textureInstanceMap[_name] = this;
    return true;
}


bool Texture2D::updateWithData(const void *data,int offsetX,int offsetY,int width,int height)
{
    if (_name)
    {
        GL::bindTexture2D(_name);
        const PixelFormatInfo& info = _pixelFormatInfoTables.at(_pixelFormat);
        glTexSubImage2D(GL_TEXTURE_2D,0,offsetX,offsetY,width,height,info.format, info.type,data);
        
        return true;
    }
    return false;
}

std::string Texture2D::getDescription() const
{
    return StringUtils::format("<Texture2D | Name = %u | Dimensions = %ld x %ld | Coordinates = (%.2f, %.2f)>", _name, (long)_pixelsWide, (long)_pixelsHigh, _maxS, _maxT);
}

// implementation Texture2D (Image)
bool Texture2D::initWithImage(Image *image)
{
    return initWithImage(image, g_defaultAlphaPixelFormat);
}

bool Texture2D::initWithImage(Image *image, PixelFormat format)
{
    if (image == nullptr)
    {
        CCLOG("cocos2d: Texture2D. Can't create Texture. UIImage is nil");
        return false;
    }
    
    int imageWidth = image->getWidth();
    int imageHeight = image->getHeight();
    
    Configuration *conf = Configuration::getInstance();
    
    int maxTextureSize = conf->getMaxTextureSize();
    if (imageWidth > maxTextureSize || imageHeight > maxTextureSize)
    {
        CCLOG("cocos2d: WARNING: Image (%u x %u) is bigger than the supported %u x %u", imageWidth, imageHeight, maxTextureSize, maxTextureSize);
        return false;
    }
    
    unsigned char*   tempData = image->getData();
    Size             imageSize = Size((float)imageWidth, (float)imageHeight);
    PixelFormat      pixelFormat = ((PixelFormat::NONE == format) || (PixelFormat::AUTO == format)) ? image->getRenderFormat() : format;
    PixelFormat      renderFormat = image->getRenderFormat();
    size_t	         tempDataLen = image->getDataLen();
    
    
    if (image->getNumberOfMipmaps() > 1)
    {
        if (pixelFormat != image->getRenderFormat())
        {
            CCLOG("cocos2d: WARNING: This image has more than 1 mipmaps and we will not convert the data format");
        }
        
        initWithMipmaps(image->getMipmaps(), image->getNumberOfMipmaps(), image->getRenderFormat(), imageWidth, imageHeight);
        
        return true;
    }
    else if (image->isCompressed())
    {
        if (pixelFormat != image->getRenderFormat())
        {
            CCLOG("cocos2d: WARNING: This image is compressed and we cann't convert it for now");
        }
        
        initWithData(tempData, tempDataLen, image->getRenderFormat(), imageWidth, imageHeight, imageSize);
        return true;
    }
    else
    {
        unsigned char* outTempData = nullptr;
        ssize_t outTempDataLen = 0;
        
        pixelFormat = convertDataToFormat(tempData, tempDataLen, renderFormat, pixelFormat, &outTempData, &outTempDataLen);
        
        initWithData(outTempData, outTempDataLen, pixelFormat, imageWidth, imageHeight, imageSize);
        
        
        if (outTempData != nullptr && outTempData != tempData)
        {
            
            free(outTempData);
        }
        
        // set the premultiplied tag
        _hasPremultipliedAlpha = image->hasPremultipliedAlpha();
        
        return true;
    }
}

Texture2D::PixelFormat Texture2D::convertI8ToFormat(const unsigned char* data, ssize_t dataLen, PixelFormat format, unsigned char** outData, ssize_t* outDataLen)
{
    switch (format)
    {
        case PixelFormat::RGBA8888:
            *outDataLen = dataLen*4;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertI8ToRGBA8888(data, dataLen, *outData);
            break;
        case PixelFormat::RGB888:
            *outDataLen = dataLen*3;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertI8ToRGB888(data, dataLen, *outData);
            break;
        case PixelFormat::RGB565:
            *outDataLen = dataLen*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertI8ToRGB565(data, dataLen, *outData);
            break;
        case PixelFormat::AI88:
            *outDataLen = dataLen*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertI8ToAI88(data, dataLen, *outData);
            break;
        case PixelFormat::RGBA4444:
            *outDataLen = dataLen*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertI8ToRGBA4444(data, dataLen, *outData);
            break;
        case PixelFormat::RGB5A1:
            *outDataLen = dataLen*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertI8ToRGB5A1(data, dataLen, *outData);
            break;
        default:
            // unsupport convertion or don't need to convert
            if (format != PixelFormat::AUTO && format != PixelFormat::I8)
            {
                CCLOG("Can not convert image format PixelFormat::I8 to format ID:%d, we will use it's origin format PixelFormat::I8", format);
            }
            
            *outData = (unsigned char*)data;
            *outDataLen = dataLen;
            return PixelFormat::I8;
    }
    
    return format;
}

Texture2D::PixelFormat Texture2D::convertAI88ToFormat(const unsigned char* data, ssize_t dataLen, PixelFormat format, unsigned char** outData, ssize_t* outDataLen)
{
    switch (format)
    {
        case PixelFormat::RGBA8888:
            *outDataLen = dataLen*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToRGBA8888(data, dataLen, *outData);
            break;
        case PixelFormat::RGB888:
            *outDataLen = dataLen/2*3;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToRGB888(data, dataLen, *outData);
            break;
        case PixelFormat::RGB565:
            *outDataLen = dataLen;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToRGB565(data, dataLen, *outData);
            break;
        case PixelFormat::A8:
            *outDataLen = dataLen/2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToA8(data, dataLen, *outData);
            break;
        case PixelFormat::I8:
            *outDataLen = dataLen/2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToI8(data, dataLen, *outData);
            break;
        case PixelFormat::RGBA4444:
            *outDataLen = dataLen;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToRGBA4444(data, dataLen, *outData);
            break;
        case PixelFormat::RGB5A1:
            *outDataLen = dataLen;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertAI88ToRGB5A1(data, dataLen, *outData);
            break;
        default:
            // unsupport convertion or don't need to convert
            if (format != PixelFormat::AUTO && format != PixelFormat::AI88)
            {
                CCLOG("Can not convert image format PixelFormat::AI88 to format ID:%d, we will use it's origin format PixelFormat::AI88", format);
            }
            
            *outData = (unsigned char*)data;
            *outDataLen = dataLen;
            return PixelFormat::AI88;
            break;
    }
    
    return format;
}

Texture2D::PixelFormat Texture2D::convertRGB888ToFormat(const unsigned char* data, ssize_t dataLen, PixelFormat format, unsigned char** outData, ssize_t* outDataLen)
{
    switch (format)
    {
        case PixelFormat::RGBA8888:
            *outDataLen = dataLen/3*4;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGB888ToRGBA8888(data, dataLen, *outData);
            break;
        case PixelFormat::RGB565:
            *outDataLen = dataLen/3*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGB888ToRGB565(data, dataLen, *outData);
            break;
        case PixelFormat::I8:
            *outDataLen = dataLen/3;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGB888ToI8(data, dataLen, *outData);
            break;
        case PixelFormat::AI88:
            *outDataLen = dataLen/3*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGB888ToAI88(data, dataLen, *outData);
            break;
        case PixelFormat::RGBA4444:
            *outDataLen = dataLen/3*2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGB888ToRGBA4444(data, dataLen, *outData);
            break;
        case PixelFormat::RGB5A1:
            *outDataLen = dataLen;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGB888ToRGB5A1(data, dataLen, *outData);
            break;
        default:
            // unsupport convertion or don't need to convert
            if (format != PixelFormat::AUTO && format != PixelFormat::RGB888)
            {
                CCLOG("Can not convert image format PixelFormat::RGB888 to format ID:%d, we will use it's origin format PixelFormat::RGB888", format);
            }
            
            *outData = (unsigned char*)data;
            *outDataLen = dataLen;
            return PixelFormat::RGB888;
    }
    return format;
}

Texture2D::PixelFormat Texture2D::convertRGBA8888ToFormat(const unsigned char* data, ssize_t dataLen, PixelFormat format, unsigned char** outData, ssize_t* outDataLen)
{
    
    switch (format)
    {
        case PixelFormat::RGB888:
            *outDataLen = dataLen/4*3;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToRGB888(data, dataLen, *outData);
            break;
        case PixelFormat::RGB565:
            *outDataLen = dataLen/2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToRGB565(data, dataLen, *outData);
            break;
        case PixelFormat::A8:
            *outDataLen = dataLen/4;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToA8(data, dataLen, *outData);
            break;
        case PixelFormat::I8:
            *outDataLen = dataLen/4;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToI8(data, dataLen, *outData);
            break;
        case PixelFormat::AI88:
            *outDataLen = dataLen/2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToAI88(data, dataLen, *outData);
            break;
        case PixelFormat::RGBA4444:
            *outDataLen = dataLen/2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToRGBA4444(data, dataLen, *outData);
            break;
        case PixelFormat::RGB5A1:
            *outDataLen = dataLen/2;
            *outData = (unsigned char*)malloc(sizeof(unsigned char) * (*outDataLen));
            convertRGBA8888ToRGB5A1(data, dataLen, *outData);
            break;
        default:
            // unsupport convertion or don't need to convert
            if (format != PixelFormat::AUTO && format != PixelFormat::RGBA8888)
            {
                CCLOG("Can not convert image format PixelFormat::RGBA8888 to format ID:%d, we will use it's origin format PixelFormat::RGBA8888", format);
            }
            
            *outData = (unsigned char*)data;
            *outDataLen = dataLen;
            return PixelFormat::RGBA8888;
    }
    
    return format;
}

/*
 convert map:
 1.PixelFormat::RGBA8888
 2.PixelFormat::RGB888
 3.PixelFormat::RGB565
 4.PixelFormat::A8
 5.PixelFormat::I8
 6.PixelFormat::AI88
 7.PixelFormat::RGBA4444
 8.PixelFormat::RGB5A1
 
 gray(5) -> 1235678
 gray alpha(6) -> 12345678
 rgb(2) -> 1235678
 rgba(1) -> 12345678
 
 */
Texture2D::PixelFormat Texture2D::convertDataToFormat(const unsigned char* data, ssize_t dataLen, PixelFormat originFormat, PixelFormat format, unsigned char** outData, ssize_t* outDataLen)
{
    // don't need to convert
    if (format == originFormat || format == PixelFormat::AUTO)
    {
        *outData = (unsigned char*)data;
        *outDataLen = dataLen;
        return originFormat;
    }
    
    switch (originFormat)
    {
        case PixelFormat::I8:
            return convertI8ToFormat(data, dataLen, format, outData, outDataLen);
        case PixelFormat::AI88:
            return convertAI88ToFormat(data, dataLen, format, outData, outDataLen);
        case PixelFormat::RGB888:
            return convertRGB888ToFormat(data, dataLen, format, outData, outDataLen);
        case PixelFormat::RGBA8888:
            return convertRGBA8888ToFormat(data, dataLen, format, outData, outDataLen);
        default:
            CCLOG("unsupport convert for format %d to format %d", originFormat, format);
            *outData = (unsigned char*)data;
            *outDataLen = dataLen;
            return originFormat;
    }
}

// implementation Texture2D (Text)
bool Texture2D::initWithString(const char *text, const std::string& fontName, float fontSize, const Size& dimensions/* = Size(0, 0)*/, TextHAlignment hAlignment/* =  TextHAlignment::CENTER */, TextVAlignment vAlignment/* =  TextVAlignment::TOP */)
{
    FontDefinition tempDef;
    
    tempDef._shadow._shadowEnabled = false;
    tempDef._stroke._strokeEnabled = false;
    
    
    tempDef._fontName      = fontName;
    tempDef._fontSize      = fontSize;
    tempDef._dimensions    = dimensions;
    tempDef._alignment     = hAlignment;
    tempDef._vertAlignment = vAlignment;
    tempDef._fontFillColor = Color3B::WHITE;
    
    return initWithString(text, tempDef);
}

bool Texture2D::initWithString(const char *text, const FontDefinition& textDefinition)
{
    if(!text || 0 == strlen(text))
    {
        return false;
    }
    
#if CC_ENABLE_CACHE_TEXTURE_DATA
    // cache the texture data
    VolatileTextureMgr::addStringTexture(this, text, textDefinition);
#endif
    
    bool ret = false;
    Device::TextAlign align;
    
    if (TextVAlignment::TOP == textDefinition._vertAlignment)
    {
        align = (TextHAlignment::CENTER == textDefinition._alignment) ? Device::TextAlign::TOP
        : (TextHAlignment::LEFT == textDefinition._alignment) ? Device::TextAlign::TOP_LEFT : Device::TextAlign::TOP_RIGHT;
    }
    else if (TextVAlignment::CENTER == textDefinition._vertAlignment)
    {
        align = (TextHAlignment::CENTER == textDefinition._alignment) ? Device::TextAlign::CENTER
        : (TextHAlignment::LEFT == textDefinition._alignment) ? Device::TextAlign::LEFT : Device::TextAlign::RIGHT;
    }
    else if (TextVAlignment::BOTTOM == textDefinition._vertAlignment)
    {
        align = (TextHAlignment::CENTER == textDefinition._alignment) ? Device::TextAlign::BOTTOM
        : (TextHAlignment::LEFT == textDefinition._alignment) ? Device::TextAlign::BOTTOM_LEFT : Device::TextAlign::BOTTOM_RIGHT;
    }
    else
    {
        CCASSERT(false, "Not supported alignment format!");
        return false;
    }
    
#if (CC_TARGET_PLATFORM != CC_PLATFORM_ANDROID) && (CC_TARGET_PLATFORM != CC_PLATFORM_IOS)
    CCASSERT(textDefinition._stroke._strokeEnabled == false, "Currently stroke only supported on iOS and Android!");
#endif
    
    PixelFormat      pixelFormat = g_defaultAlphaPixelFormat;
    unsigned char* outTempData = nullptr;
    ssize_t outTempDataLen = 0;
    
    int imageWidth;
    int imageHeight;
    auto textDef = textDefinition;
    auto contentScaleFactor = CC_CONTENT_SCALE_FACTOR();
    textDef._fontSize *= contentScaleFactor;
    textDef._dimensions.width *= contentScaleFactor;
    textDef._dimensions.height *= contentScaleFactor;
    textDef._stroke._strokeSize *= contentScaleFactor;
    textDef._shadow._shadowEnabled = false;
    
    bool hasPremultipliedAlpha;
    Data outData = Device::getTextureDataForText(text, textDef, align, imageWidth, imageHeight, hasPremultipliedAlpha);
    if(outData.isNull())
    {
        return false;
    }
    
    Size  imageSize = Size((float)imageWidth, (float)imageHeight);
    pixelFormat = convertDataToFormat(outData.getBytes(), imageWidth*imageHeight*4, PixelFormat::RGBA8888, pixelFormat, &outTempData, &outTempDataLen);
    
    ret = initWithData(outTempData, outTempDataLen, pixelFormat, imageWidth, imageHeight, imageSize);
    
    if (outTempData != nullptr && outTempData != outData.getBytes())
    {
        free(outTempData);
    }
    _hasPremultipliedAlpha = hasPremultipliedAlpha;
    
    return ret;
}


// implementation Texture2D (Drawing)

void Texture2D::drawAtPoint(const Vec2& point)
{
    GLfloat    coordinates[] = {
        0.0f,    _maxT,
        _maxS,_maxT,
        0.0f,    0.0f,
        _maxS,0.0f };
    
    GLfloat    width = (GLfloat)_pixelsWide * _maxS,
    height = (GLfloat)_pixelsHigh * _maxT;
    
    GLfloat        vertices[] = {
        point.x,            point.y,
        width + point.x,    point.y,
        point.x,            height  + point.y,
        width + point.x,    height  + point.y };
    
    GL::enableVertexAttribs( GL::VERTEX_ATTRIB_FLAG_POSITION | GL::VERTEX_ATTRIB_FLAG_TEX_COORD );
    _shaderProgram->use();
    _shaderProgram->setUniformsForBuiltins();
    
    GL::bindTexture2D( _name );
    
    
#ifdef EMSCRIPTEN
    setGLBufferData(vertices, 8 * sizeof(GLfloat), 0);
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_POSITION, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    setGLBufferData(coordinates, 8 * sizeof(GLfloat), 1);
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, 0);
#else
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_POSITION, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, coordinates);
#endif // EMSCRIPTEN
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void Texture2D::drawInRect(const Rect& rect)
{
    GLfloat    coordinates[] = {
        0.0f,    _maxT,
        _maxS,_maxT,
        0.0f,    0.0f,
        _maxS,0.0f };
    
    GLfloat    vertices[] = {    rect.origin.x,        rect.origin.y,                            /*0.0f,*/
        rect.origin.x + rect.size.width,        rect.origin.y,                            /*0.0f,*/
        rect.origin.x,                            rect.origin.y + rect.size.height,        /*0.0f,*/
        rect.origin.x + rect.size.width,        rect.origin.y + rect.size.height,        /*0.0f*/ };
    
    GL::enableVertexAttribs( GL::VERTEX_ATTRIB_FLAG_POSITION | GL::VERTEX_ATTRIB_FLAG_TEX_COORD );
    _shaderProgram->use();
    _shaderProgram->setUniformsForBuiltins();
    
    GL::bindTexture2D( _name );
    
#ifdef EMSCRIPTEN
    setGLBufferData(vertices, 8 * sizeof(GLfloat), 0);
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_POSITION, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    setGLBufferData(coordinates, 8 * sizeof(GLfloat), 1);
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, 0);
#else
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_POSITION, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLProgram::VERTEX_ATTRIB_TEX_COORD, 2, GL_FLOAT, GL_FALSE, 0, coordinates);
#endif // EMSCRIPTEN
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void Texture2D::PVRImagesHavePremultipliedAlpha(bool haveAlphaPremultiplied)
{
    Image::setPVRImagesHavePremultipliedAlpha(haveAlphaPremultiplied);
}


//
// Use to apply MIN/MAG filter
//
// implementation Texture2D (GLFilter)

void Texture2D::generateMipmap()
{
    CCASSERT(_pixelsWide == ccNextPOT(_pixelsWide) && _pixelsHigh == ccNextPOT(_pixelsHigh), "Mipmap texture only works in POT textures");
    GL::bindTexture2D( _name );
    glGenerateMipmap(GL_TEXTURE_2D);
    _hasMipmaps = true;
#if CC_ENABLE_CACHE_TEXTURE_DATA
    VolatileTextureMgr::setHasMipmaps(this, _hasMipmaps);
#endif
}

bool Texture2D::hasMipmaps() const
{
    return _hasMipmaps;
}

void Texture2D::setTexParameters(const TexParams &texParams)
{
    CCASSERT((_pixelsWide == ccNextPOT(_pixelsWide) || texParams.wrapS == GL_CLAMP_TO_EDGE) &&
             (_pixelsHigh == ccNextPOT(_pixelsHigh) || texParams.wrapT == GL_CLAMP_TO_EDGE),
             "GL_CLAMP_TO_EDGE should be used in NPOT dimensions");
    
    GL::bindTexture2D( _name );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, texParams.minFilter );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, texParams.magFilter );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, texParams.wrapS );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, texParams.wrapT );
    
#if CC_ENABLE_CACHE_TEXTURE_DATA
    VolatileTextureMgr::setTexParameters(this, texParams);
#endif
}

void Texture2D::setAliasTexParameters()
{
    if (! _antialiasEnabled)
    {
        return;
    }
    
    _antialiasEnabled = false;
    
    if (_name == 0)
    {
        return;
    }
    
    GL::bindTexture2D( _name );
    
    if( ! _hasMipmaps )
    {
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
    }
    else
    {
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST );
    }
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
#if CC_ENABLE_CACHE_TEXTURE_DATA
    TexParams texParams = {(GLuint)(_hasMipmaps?GL_NEAREST_MIPMAP_NEAREST:GL_NEAREST),GL_NEAREST,GL_NONE,GL_NONE};
    VolatileTextureMgr::setTexParameters(this, texParams);
#endif
}

void Texture2D::setAntiAliasTexParameters()
{
    if ( _antialiasEnabled )
    {
        return;
    }
    
    _antialiasEnabled = true;
    
    if (_name == 0)
    {
        return;
    }
    
    GL::bindTexture2D( _name );
    
    if( ! _hasMipmaps )
    {
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    }
    else
    {
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST );
    }
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
#if CC_ENABLE_CACHE_TEXTURE_DATA
    TexParams texParams = {(GLuint)(_hasMipmaps?GL_LINEAR_MIPMAP_NEAREST:GL_LINEAR),GL_LINEAR,GL_NONE,GL_NONE};
    VolatileTextureMgr::setTexParameters(this, texParams);
#endif
}

const char* Texture2D::getStringForFormat() const
{
    switch (_pixelFormat)
    {
        case Texture2D::PixelFormat::RGBA8888:
            return  "RGBA8888";
            
        case Texture2D::PixelFormat::RGB888:
            return  "RGB888";
            
        case Texture2D::PixelFormat::RGB565:
            return  "RGB565";
            
        case Texture2D::PixelFormat::RGBA4444:
            return  "RGBA4444";
            
        case Texture2D::PixelFormat::RGB5A1:
            return  "RGB5A1";
            
        case Texture2D::PixelFormat::AI88:
            return  "AI88";
            
        case Texture2D::PixelFormat::A8:
            return  "A8";
            
        case Texture2D::PixelFormat::I8:
            return  "I8";
            
        case Texture2D::PixelFormat::PVRTC4:
            return  "PVRTC4";
            
        case Texture2D::PixelFormat::PVRTC2:
            return  "PVRTC2";
            
        default:
            CCASSERT(false , "unrecognized pixel format");
            CCLOG("stringForFormat: %ld, cannot give useful result", (long)_pixelFormat);
            break;
    }
    
    return  nullptr;
}

//
// Texture options for images that contains alpha
//
// implementation Texture2D (PixelFormat)

void Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat format)
{
    g_defaultAlphaPixelFormat = format;
}

Texture2D::PixelFormat Texture2D::getDefaultAlphaPixelFormat()
{
    return g_defaultAlphaPixelFormat;
}

unsigned int Texture2D::getBitsPerPixelForFormat(Texture2D::PixelFormat format) const
{
    if (format == PixelFormat::NONE || format == PixelFormat::DEFAULT)
    {
        return 0;
    }
    
    return _pixelFormatInfoTables.at(format).bpp;
}

unsigned int Texture2D::getBitsPerPixelForFormat() const
{
    return this->getBitsPerPixelForFormat(_pixelFormat);
}

const Texture2D::PixelFormatInfoMap& Texture2D::getPixelFormatInfoMap()
{
    return _pixelFormatInfoTables;
}



NS_CC_END

#endif//CC_PLATFORM_IOS_METAL
