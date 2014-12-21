/****************************************************************************
Copyright (c) 2011      Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (C) 2013-2014 Chukong Technologies Inc.

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

#include "renderer/ccGLStateCache.h"

#if CC_PLATFORM_IOS_METAL

NS_CC_BEGIN
namespace GL {
    /** Invalidates the GL state cache.
     If CC_ENABLE_GL_STATE_CACHE it will reset the GL state cache.
     @since v2.0.0
     */
    void CC_DLL invalidateStateCache(void) {}
    
    /** Uses the GL program in case program is different than the current one.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will the glUseProgram() directly.
     @since v2.0.0
     */
    void CC_DLL useProgram(GLuint program){}
    
    /** Deletes the GL program. If it is the one that is being used, it invalidates it.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will the glDeleteProgram() directly.
     @since v2.0.0
     */
    void CC_DLL deleteProgram(GLuint program){}
    
    /** Uses a blending function in case it not already used.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will the glBlendFunc() directly.
     @since v2.0.0
     */
    void CC_DLL blendFunc(GLenum sfactor, GLenum dfactor){}
    
    /** Resets the blending mode back to the cached state in case you used glBlendFuncSeparate() or glBlendEquation().
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will just set the default blending mode using GL_FUNC_ADD.
     @since v2.0.0
     */
    void CC_DLL blendResetToCache(void){}
    
    /** sets the projection matrix as dirty
     @since v2.0.0
     */
    void CC_DLL setProjectionMatrixDirty(void){}
    
    /** Will enable the vertex attribs that are passed as flags.
     Possible flags:
     
     * VERTEX_ATTRIB_FLAG_POSITION
     * VERTEX_ATTRIB_FLAG_COLOR
     * VERTEX_ATTRIB_FLAG_TEX_COORDS
     
     These flags can be ORed. The flags that are not present, will be disabled.
     
     @since v2.0.0
     */
    void CC_DLL enableVertexAttribs(uint32_t flags){}
    
    /** If the texture is not already bound to texture unit 0, it binds it.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will call glBindTexture() directly.
     @since v2.0.0
     */
    void CC_DLL bindTexture2D(GLuint textureId){}
    
    
    /** If the texture is not already bound to a given unit, it binds it.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will call glBindTexture() directly.
     @since v2.1.0
     */
    void CC_DLL bindTexture2DN(GLuint textureUnit, GLuint textureId){}
    
    /** It will delete a given texture. If the texture was bound, it will invalidate the cached.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will call glDeleteTextures() directly.
     @since v2.0.0
     */
    void CC_DLL deleteTexture(GLuint textureId){}
    
    /** It will delete a given texture. If the texture was bound, it will invalidate the cached for the given texture unit.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will call glDeleteTextures() directly.
     @since v2.1.0
     */
    CC_DEPRECATED_ATTRIBUTE void CC_DLL deleteTextureN(GLuint textureUnit, GLuint textureId){}
    
    /** Select active texture unit.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will call glActiveTexture() directly.
     @since v3.0
     */
    void CC_DLL activeTexture(GLenum texture){}
    
    /** If the vertex array is not already bound, it binds it.
     If CC_ENABLE_GL_STATE_CACHE is disabled, it will call glBindVertexArray() directly.
     @since v2.0.0
     */
    void CC_DLL bindVAO(GLuint vaoId){}

}
NS_CC_END

//======================================================================================================
#else//CC_PLATFORM_IOS_METAL
//======================================================================================================

#include "renderer/CCGLProgram.h"
#include "base/CCDirector.h"
#include "base/ccConfig.h"
#include "base/CCConfiguration.h"

NS_CC_BEGIN

static const int MAX_ATTRIBUTES = 16;
static const int MAX_ACTIVE_TEXTURE = 16;

namespace
{
    static GLuint s_currentProjectionMatrix = -1;
    static uint32_t s_attributeFlags = 0;  // 32 attributes max

#if CC_ENABLE_GL_STATE_CACHE

    static GLuint    s_currentShaderProgram = -1;
    static GLuint    s_currentBoundTexture[MAX_ACTIVE_TEXTURE] =  {(GLuint)-1,(GLuint)-1,(GLuint)-1,(GLuint)-1, (GLuint)-1,(GLuint)-1,(GLuint)-1,(GLuint)-1, (GLuint)-1,(GLuint)-1,(GLuint)-1,(GLuint)-1, (GLuint)-1,(GLuint)-1,(GLuint)-1,(GLuint)-1, };
    static GLenum    s_blendingSource = -1;
    static GLenum    s_blendingDest = -1;
    static int       s_GLServerState = 0;
    static GLuint    s_VAO = 0;
    static GLenum    s_activeTexture = -1;

#endif // CC_ENABLE_GL_STATE_CACHE
}

// GL State Cache functions

namespace GL {

void invalidateStateCache( void )
{
    Director::getInstance()->resetMatrixStack();
    s_currentProjectionMatrix = -1;
    s_attributeFlags = 0;

#if CC_ENABLE_GL_STATE_CACHE
    s_currentShaderProgram = -1;
    for( int i=0; i < MAX_ACTIVE_TEXTURE; i++ )
    {
        s_currentBoundTexture[i] = -1;
    }

    s_blendingSource = -1;
    s_blendingDest = -1;
    s_GLServerState = 0;
    s_VAO = 0;
    
#endif // CC_ENABLE_GL_STATE_CACHE
}

void deleteProgram( GLuint program )
{
#if CC_ENABLE_GL_STATE_CACHE
    if(program == s_currentShaderProgram)
    {
        s_currentShaderProgram = -1;
    }
#endif // CC_ENABLE_GL_STATE_CACHE

    glDeleteProgram( program );
}

void useProgram( GLuint program )
{
#if CC_ENABLE_GL_STATE_CACHE
    if( program != s_currentShaderProgram ) {
        s_currentShaderProgram = program;
        glUseProgram(program);
    }
#else
    glUseProgram(program);
#endif // CC_ENABLE_GL_STATE_CACHE
}

static void SetBlending(GLenum sfactor, GLenum dfactor)
{
	if (sfactor == GL_ONE && dfactor == GL_ZERO)
    {
		glDisable(GL_BLEND);
	}
    else
    {
		glEnable(GL_BLEND);
		glBlendFunc(sfactor, dfactor);
	}
}

void blendFunc(GLenum sfactor, GLenum dfactor)
{
#if CC_ENABLE_GL_STATE_CACHE
    if (sfactor != s_blendingSource || dfactor != s_blendingDest)
    {
        s_blendingSource = sfactor;
        s_blendingDest = dfactor;
        SetBlending(sfactor, dfactor);
    }
#else
    SetBlending( sfactor, dfactor );
#endif // CC_ENABLE_GL_STATE_CACHE
}

void blendResetToCache(void)
{
	glBlendEquation(GL_FUNC_ADD);
#if CC_ENABLE_GL_STATE_CACHE
	SetBlending(s_blendingSource, s_blendingDest);
#else
	SetBlending(CC_BLEND_SRC, CC_BLEND_DST);
#endif // CC_ENABLE_GL_STATE_CACHE
}

void bindTexture2D(GLuint textureId)
{
    GL::bindTexture2DN(0, textureId);
}

void bindTexture2DN(GLuint textureUnit, GLuint textureId)
{
#if CC_ENABLE_GL_STATE_CACHE
    CCASSERT(textureUnit < MAX_ACTIVE_TEXTURE, "textureUnit is too big");
    if (s_currentBoundTexture[textureUnit] != textureId)
    {
        s_currentBoundTexture[textureUnit] = textureId;
        activeTexture(GL_TEXTURE0 + textureUnit);
        glBindTexture(GL_TEXTURE_2D, textureId);
    }
#else
    glActiveTexture(GL_TEXTURE0 + textureUnit);
    glBindTexture(GL_TEXTURE_2D, textureId);
#endif
}


void deleteTexture(GLuint textureId)
{
#if CC_ENABLE_GL_STATE_CACHE
    for (size_t i = 0; i < MAX_ACTIVE_TEXTURE; ++i)
    {
        if (s_currentBoundTexture[i] == textureId)
        {
            s_currentBoundTexture[i] = -1;
        }
    }
#endif // CC_ENABLE_GL_STATE_CACHE
    
	glDeleteTextures(1, &textureId);
}

void deleteTextureN(GLuint textureUnit, GLuint textureId)
{
    deleteTexture(textureId);
}

void activeTexture(GLenum texture)
{
#if CC_ENABLE_GL_STATE_CACHE
    if(s_activeTexture != texture) {
        s_activeTexture = texture;
        glActiveTexture(s_activeTexture);
    }
#else
    glActiveTexture(texture);
#endif
}

void bindVAO(GLuint vaoId)
{
    if (Configuration::getInstance()->supportsShareableVAO())
    {
    
#if CC_ENABLE_GL_STATE_CACHE
        if (s_VAO != vaoId)
        {
            s_VAO = vaoId;
            glBindVertexArray(vaoId);
        }
#else
        glBindVertexArray(vaoId);
#endif // CC_ENABLE_GL_STATE_CACHE
    
    }
}

// GL Vertex Attrib functions

void enableVertexAttribs(uint32_t flags)
{
    bindVAO(0);

    // hardcoded!
    for(int i=0; i < MAX_ATTRIBUTES; i++) {
        unsigned int bit = 1 << i;
        bool enabled = flags & bit;
        bool enabledBefore = s_attributeFlags & bit;
        if(enabled != enabledBefore) {
            if( enabled )
                glEnableVertexAttribArray(i);
            else
                glDisableVertexAttribArray(i);
        }
    }
    s_attributeFlags = flags;
}

// GL Uniforms functions

void setProjectionMatrixDirty( void )
{
    s_currentProjectionMatrix = -1;
}

} // Namespace GL

NS_CC_END

#endif//CC_PLATFORM_IOS_METAL
