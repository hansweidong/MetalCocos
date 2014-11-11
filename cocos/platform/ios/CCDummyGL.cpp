
#include "platform/CCPlatformConfig.h"
#include "platform/ios/CCDummyGL.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
#if CC_PLATFORM_IOS_METAL

/*  GLをエミュレーションするのはMETAL使う意味ないよな。
    てことは、もっと上の層でMetalに差し替える必要がある。
    まぁCommandから先のレンダラをとっかえて。となるだろう
 */

GL_API void           GL_APIENTRY glActiveTexture (GLenum texture){}
GL_API void           GL_APIENTRY glAttachShader (GLuint program, GLuint shader)  {}
GL_API void           GL_APIENTRY glBindAttribLocation (GLuint program, GLuint index, const GLchar* name)  {}
GL_API void           GL_APIENTRY glBindBuffer (GLenum target, GLuint buffer){}
GL_API void           GL_APIENTRY glBindFramebuffer (GLenum target, GLuint framebuffer)  {}
GL_API void           GL_APIENTRY glBindRenderbuffer (GLenum target, GLuint renderbuffer)  {}
GL_API void           GL_APIENTRY glBindTexture (GLenum target, GLuint texture){}
GL_API void           GL_APIENTRY glBlendColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)  {}
GL_API void           GL_APIENTRY glBlendEquation (GLenum mode)  {}
GL_API void           GL_APIENTRY glBlendEquationSeparate (GLenum modeRGB, GLenum modeAlpha)  {}
GL_API void           GL_APIENTRY glBlendFunc (GLenum sfactor, GLenum dfactor){}
GL_API void           GL_APIENTRY glBlendFuncSeparate (GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha)  {}
GL_API void           GL_APIENTRY glBufferData (GLenum target, GLsizeiptr size, const GLvoid* data, GLenum usage){}
GL_API void           GL_APIENTRY glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid* data){}
GL_API GLenum         GL_APIENTRY glCheckFramebufferStatus (GLenum target)  {return -1;}
GL_API void           GL_APIENTRY glClear (GLbitfield mask){}
GL_API void           GL_APIENTRY glClearColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha){}
GL_API void           GL_APIENTRY glClearDepthf (GLclampf depth){}
GL_API void           GL_APIENTRY glClearStencil (GLint s){}
GL_API void           GL_APIENTRY glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha){}
GL_API void           GL_APIENTRY glCompileShader (GLuint shader)  {}
GL_API void           GL_APIENTRY glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid* data){}
GL_API void           GL_APIENTRY glCompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid* data){}
GL_API void           GL_APIENTRY glCopyTexImage2D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border){}
GL_API void           GL_APIENTRY glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height){}
GL_API GLuint         GL_APIENTRY glCreateProgram (void)  {return -1;}
GL_API GLuint         GL_APIENTRY glCreateShader (GLenum type)  {return -1;}
GL_API void           GL_APIENTRY glCullFace (GLenum mode){}
GL_API void           GL_APIENTRY glDeleteBuffers (GLsizei n, const GLuint* buffers){}
GL_API void           GL_APIENTRY glDeleteFramebuffers (GLsizei n, const GLuint* framebuffers)  {}
GL_API void           GL_APIENTRY glDeleteProgram (GLuint program)  {}
GL_API void           GL_APIENTRY glDeleteRenderbuffers (GLsizei n, const GLuint* renderbuffers)  {}
GL_API void           GL_APIENTRY glDeleteShader (GLuint shader)  {}
GL_API void           GL_APIENTRY glDeleteTextures (GLsizei n, const GLuint* textures){}
GL_API void           GL_APIENTRY glDepthFunc (GLenum func){}
GL_API void           GL_APIENTRY glDepthMask (GLboolean flag){}
GL_API void           GL_APIENTRY glDepthRangef (GLclampf zNear, GLclampf zFar){}
GL_API void           GL_APIENTRY glDetachShader (GLuint program, GLuint shader)  {}
GL_API void           GL_APIENTRY glDisable (GLenum cap){}
GL_API void           GL_APIENTRY glDisableVertexAttribArray (GLuint index)  {}
GL_API void           GL_APIENTRY glDrawArrays (GLenum mode, GLint first, GLsizei count){}
GL_API void           GL_APIENTRY glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid* indices){}
GL_API void           GL_APIENTRY glEnable (GLenum cap){}
GL_API void           GL_APIENTRY glEnableVertexAttribArray (GLuint index)  {}
GL_API void           GL_APIENTRY glFinish (void){}
GL_API void           GL_APIENTRY glFlush (void){}
GL_API void           GL_APIENTRY glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)  {}
GL_API void           GL_APIENTRY glFramebufferTexture2D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)  {}
GL_API void           GL_APIENTRY glFrontFace (GLenum mode){}
GL_API void           GL_APIENTRY glGenBuffers (GLsizei n, GLuint* buffers){}
GL_API void           GL_APIENTRY glGenerateMipmap (GLenum target)  {}
GL_API void           GL_APIENTRY glGenFramebuffers (GLsizei n, GLuint* framebuffers)  {}
GL_API void           GL_APIENTRY glGenRenderbuffers (GLsizei n, GLuint* renderbuffers)  {}
GL_API void           GL_APIENTRY glGenTextures (GLsizei n, GLuint* textures){}
GL_API void           GL_APIENTRY glGetActiveAttrib (GLuint program, GLuint index, GLsizei bufsize, GLsizei* length, GLint* size, GLenum* type, GLchar* name)  {}
GL_API void           GL_APIENTRY glGetActiveUniform (GLuint program, GLuint index, GLsizei bufsize, GLsizei* length, GLint* size, GLenum* type, GLchar* name)  {}
GL_API void           GL_APIENTRY glGetAttachedShaders (GLuint program, GLsizei maxcount, GLsizei* count, GLuint* shaders)  {}
GL_API int            GL_APIENTRY glGetAttribLocation (GLuint program, const GLchar* name)  {return -1;}
GL_API void           GL_APIENTRY glGetBooleanv (GLenum pname, GLboolean* params){}
GL_API void           GL_APIENTRY glGetBufferParameteriv (GLenum target, GLenum pname, GLint* params){}
GL_API GLenum         GL_APIENTRY glGetError (void){return -1;}
GL_API void           GL_APIENTRY glGetFloatv (GLenum pname, GLfloat* params){}
GL_API void           GL_APIENTRY glGetFramebufferAttachmentParameteriv (GLenum target, GLenum attachment, GLenum pname, GLint* params)  {}
GL_API void           GL_APIENTRY glGetIntegerv (GLenum pname, GLint* params){}
GL_API void           GL_APIENTRY glGetProgramiv (GLuint program, GLenum pname, GLint* params)  {}
GL_API void           GL_APIENTRY glGetProgramInfoLog (GLuint program, GLsizei bufsize, GLsizei* length, GLchar* infolog)  {}
GL_API void           GL_APIENTRY glGetRenderbufferParameteriv (GLenum target, GLenum pname, GLint* params)  {}
GL_API void           GL_APIENTRY glGetShaderiv (GLuint shader, GLenum pname, GLint* params)  {}
GL_API void           GL_APIENTRY glGetShaderInfoLog (GLuint shader, GLsizei bufsize, GLsizei* length, GLchar* infolog)  {}
GL_API void           GL_APIENTRY glGetShaderPrecisionFormat (GLenum shadertype, GLenum precisiontype, GLint* range, GLint* precision)  {}
GL_API void           GL_APIENTRY glGetShaderSource (GLuint shader, GLsizei bufsize, GLsizei* length, GLchar* source)  {}
GL_API const GLubyte* GL_APIENTRY glGetString (GLenum name){return NULL;}
GL_API void           GL_APIENTRY glGetTexParameterfv (GLenum target, GLenum pname, GLfloat* params){}
GL_API void           GL_APIENTRY glGetTexParameteriv (GLenum target, GLenum pname, GLint* params){}
GL_API void           GL_APIENTRY glGetUniformfv (GLuint program, GLint location, GLfloat* params)  {}
GL_API void           GL_APIENTRY glGetUniformiv (GLuint program, GLint location, GLint* params)  {}
GL_API int            GL_APIENTRY glGetUniformLocation (GLuint program, const GLchar* name)  {return -1;}
GL_API void           GL_APIENTRY glGetVertexAttribfv (GLuint index, GLenum pname, GLfloat* params)  {}
GL_API void           GL_APIENTRY glGetVertexAttribiv (GLuint index, GLenum pname, GLint* params)  {}
GL_API void           GL_APIENTRY glGetVertexAttribPointerv (GLuint index, GLenum pname, GLvoid** pointer)  {}
GL_API void           GL_APIENTRY glHint (GLenum target, GLenum mode){}
GL_API GLboolean      GL_APIENTRY glIsBuffer (GLuint buffer){return false;}
GL_API GLboolean      GL_APIENTRY glIsEnabled (GLenum cap){return false;}
GL_API GLboolean      GL_APIENTRY glIsFramebuffer (GLuint framebuffer)  {return false;}
GL_API GLboolean      GL_APIENTRY glIsProgram (GLuint program){return false;}
GL_API GLboolean      GL_APIENTRY glIsRenderbuffer (GLuint renderbuffer)  {return false;}
GL_API GLboolean      GL_APIENTRY glIsShader (GLuint shader)  {return false;}
GL_API GLboolean      GL_APIENTRY glIsTexture (GLuint texture){return false;}
GL_API void           GL_APIENTRY glLineWidth (GLfloat width){}
GL_API void           GL_APIENTRY glLinkProgram (GLuint program)  {}
GL_API void           GL_APIENTRY glPixelStorei (GLenum pname, GLint param){}
GL_API void           GL_APIENTRY glPolygonOffset (GLfloat factor, GLfloat units){}
GL_API void           GL_APIENTRY glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid* pixels){}
GL_API void           GL_APIENTRY glReleaseShaderCompiler (void)  {}
GL_API void           GL_APIENTRY glRenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height)  {}
GL_API void           GL_APIENTRY glSampleCoverage (GLclampf value, GLboolean invert){}
GL_API void           GL_APIENTRY glScissor (GLint x, GLint y, GLsizei width, GLsizei height){}
GL_API void           GL_APIENTRY glShaderBinary (GLsizei n, const GLuint* shaders, GLenum binaryformat, const GLvoid* binary, GLsizei length)  {}
GL_API void           GL_APIENTRY glShaderSource (GLuint shader, GLsizei count, const GLchar* const *string, const GLint* length)  {}
GL_API void           GL_APIENTRY glStencilFunc (GLenum func, GLint ref, GLuint mask){}
GL_API void           GL_APIENTRY glStencilFuncSeparate (GLenum face, GLenum func, GLint ref, GLuint mask)  {}
GL_API void           GL_APIENTRY glStencilMask (GLuint mask){}
GL_API void           GL_APIENTRY glStencilMaskSeparate (GLenum face, GLuint mask)  {}
GL_API void           GL_APIENTRY glStencilOp (GLenum fail, GLenum zfail, GLenum zpass){}
GL_API void           GL_APIENTRY glStencilOpSeparate (GLenum face, GLenum fail, GLenum zfail, GLenum zpass)  {}
GL_API void           GL_APIENTRY glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid* pixels){}
GL_API void           GL_APIENTRY glTexParameterf (GLenum target, GLenum pname, GLfloat param){}
GL_API void           GL_APIENTRY glTexParameterfv (GLenum target, GLenum pname, const GLfloat* params){}
GL_API void           GL_APIENTRY glTexParameteri (GLenum target, GLenum pname, GLint param){}
GL_API void           GL_APIENTRY glTexParameteriv (GLenum target, GLenum pname, const GLint* params){}
GL_API void           GL_APIENTRY glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid* pixels){}
GL_API void           GL_APIENTRY glUniform1f (GLint location, GLfloat x)  {}
GL_API void           GL_APIENTRY glUniform1fv (GLint location, GLsizei count, const GLfloat* v)  {}
GL_API void           GL_APIENTRY glUniform1i (GLint location, GLint x)  {}
GL_API void           GL_APIENTRY glUniform1iv (GLint location, GLsizei count, const GLint* v)  {}
GL_API void           GL_APIENTRY glUniform2f (GLint location, GLfloat x, GLfloat y)  {}
GL_API void           GL_APIENTRY glUniform2fv (GLint location, GLsizei count, const GLfloat* v)  {}
GL_API void           GL_APIENTRY glUniform2i (GLint location, GLint x, GLint y)  {}
GL_API void           GL_APIENTRY glUniform2iv (GLint location, GLsizei count, const GLint* v)  {}
GL_API void           GL_APIENTRY glUniform3f (GLint location, GLfloat x, GLfloat y, GLfloat z)  {}
GL_API void           GL_APIENTRY glUniform3fv (GLint location, GLsizei count, const GLfloat* v)  {}
GL_API void           GL_APIENTRY glUniform3i (GLint location, GLint x, GLint y, GLint z)  {}
GL_API void           GL_APIENTRY glUniform3iv (GLint location, GLsizei count, const GLint* v)  {}
GL_API void           GL_APIENTRY glUniform4f (GLint location, GLfloat x, GLfloat y, GLfloat z, GLfloat w)  {}
GL_API void           GL_APIENTRY glUniform4fv (GLint location, GLsizei count, const GLfloat* v)  {}
GL_API void           GL_APIENTRY glUniform4i (GLint location, GLint x, GLint y, GLint z, GLint w)  {}
GL_API void           GL_APIENTRY glUniform4iv (GLint location, GLsizei count, const GLint* v)  {}
GL_API void           GL_APIENTRY glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  {}
GL_API void           GL_APIENTRY glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  {}
GL_API void           GL_APIENTRY glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  {}
GL_API void           GL_APIENTRY glUseProgram (GLuint program)  {}
GL_API void           GL_APIENTRY glValidateProgram (GLuint program)  {}
GL_API void           GL_APIENTRY glVertexAttrib1f (GLuint indx, GLfloat x)  {}
GL_API void           GL_APIENTRY glVertexAttrib1fv (GLuint indx, const GLfloat* values)  {}
GL_API void           GL_APIENTRY glVertexAttrib2f (GLuint indx, GLfloat x, GLfloat y)  {}
GL_API void           GL_APIENTRY glVertexAttrib2fv (GLuint indx, const GLfloat* values)  {}
GL_API void           GL_APIENTRY glVertexAttrib3f (GLuint indx, GLfloat x, GLfloat y, GLfloat z)  {}
GL_API void           GL_APIENTRY glVertexAttrib3fv (GLuint indx, const GLfloat* values)  {}
GL_API void           GL_APIENTRY glVertexAttrib4f (GLuint indx, GLfloat x, GLfloat y, GLfloat z, GLfloat w)  {}
GL_API void           GL_APIENTRY glVertexAttrib4fv (GLuint indx, const GLfloat* values)  {}
GL_API void           GL_APIENTRY glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)  {}
GL_API void           GL_APIENTRY glViewport (GLint x, GLint y, GLsizei width, GLsizei height){}


#if 0

    GL_API void           GL_APIENTRY glCullFace (GLenum mode);
    GL_API void           GL_APIENTRY glPixelStorei (GLenum pname, GLint param);
    GL_API void           GL_APIENTRY glGenTextures (GLsizei n, GLuint* textures);
    GL_API void           GL_APIENTRY glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid* data);
    GL_API void           GL_APIENTRY glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid* pixels);
    GL_API void           GL_APIENTRY glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform4f (GLint location, GLfloat x, GLfloat y, GLfloat z, GLfloat w)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform3f (GLint location, GLfloat x, GLfloat y, GLfloat z)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);

    
    
    
    
    GL_API void           GL_APIENTRY glActiveTexture (GLenum texture);
    GL_API void           GL_APIENTRY glAttachShader (GLuint program, GLuint shader)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBindAttribLocation (GLuint program, GLuint index, const GLchar* name)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBindBuffer (GLenum target, GLuint buffer);
    GL_API void           GL_APIENTRY glBindFramebuffer (GLenum target, GLuint framebuffer)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBindRenderbuffer (GLenum target, GLuint renderbuffer)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBindTexture (GLenum target, GLuint texture);
    GL_API void           GL_APIENTRY glBlendColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBlendEquation (GLenum mode)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBlendEquationSeparate (GLenum modeRGB, GLenum modeAlpha)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBlendFunc (GLenum sfactor, GLenum dfactor);
    GL_API void           GL_APIENTRY glBlendFuncSeparate (GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glBufferData (GLenum target, GLsizeiptr size, const GLvoid* data, GLenum usage);
    GL_API void           GL_APIENTRY glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid* data);
    GL_API GLenum         GL_APIENTRY glCheckFramebufferStatus (GLenum target)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glClear (GLbitfield mask);
    GL_API void           GL_APIENTRY glClearColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
    GL_API void           GL_APIENTRY glClearDepthf (GLclampf depth);
    GL_API void           GL_APIENTRY glClearStencil (GLint s);
    GL_API void           GL_APIENTRY glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
    GL_API void           GL_APIENTRY glCompileShader (GLuint shader)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid* data);
    GL_API void           GL_APIENTRY glCompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid* data);
    GL_API void           GL_APIENTRY glCopyTexImage2D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
    GL_API void           GL_APIENTRY glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
    GL_API GLuint         GL_APIENTRY glCreateProgram (void)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API GLuint         GL_APIENTRY glCreateShader (GLenum type)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glCullFace (GLenum mode);
    GL_API void           GL_APIENTRY glDeleteBuffers (GLsizei n, const GLuint* buffers);
    GL_API void           GL_APIENTRY glDeleteFramebuffers (GLsizei n, const GLuint* framebuffers)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glDeleteProgram (GLuint program)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glDeleteRenderbuffers (GLsizei n, const GLuint* renderbuffers)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glDeleteShader (GLuint shader)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glDeleteTextures (GLsizei n, const GLuint* textures);
    GL_API void           GL_APIENTRY glDepthFunc (GLenum func);
    GL_API void           GL_APIENTRY glDepthMask (GLboolean flag);
    GL_API void           GL_APIENTRY glDepthRangef (GLclampf zNear, GLclampf zFar);
    GL_API void           GL_APIENTRY glDetachShader (GLuint program, GLuint shader)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glDisable (GLenum cap);
    GL_API void           GL_APIENTRY glDisableVertexAttribArray (GLuint index)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glDrawArrays (GLenum mode, GLint first, GLsizei count);
    GL_API void           GL_APIENTRY glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid* indices);
    GL_API void           GL_APIENTRY glEnable (GLenum cap);
    GL_API void           GL_APIENTRY glEnableVertexAttribArray (GLuint index)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glFinish (void);
    GL_API void           GL_APIENTRY glFlush (void);
    GL_API void           GL_APIENTRY glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glFramebufferTexture2D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glFrontFace (GLenum mode);
    GL_API void           GL_APIENTRY glGenBuffers (GLsizei n, GLuint* buffers);
    GL_API void           GL_APIENTRY glGenerateMipmap (GLenum target)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGenFramebuffers (GLsizei n, GLuint* framebuffers)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGenRenderbuffers (GLsizei n, GLuint* renderbuffers)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGenTextures (GLsizei n, GLuint* textures);
    GL_API void           GL_APIENTRY glGetActiveAttrib (GLuint program, GLuint index, GLsizei bufsize, GLsizei* length, GLint* size, GLenum* type, GLchar* name)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetActiveUniform (GLuint program, GLuint index, GLsizei bufsize, GLsizei* length, GLint* size, GLenum* type, GLchar* name)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetAttachedShaders (GLuint program, GLsizei maxcount, GLsizei* count, GLuint* shaders)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API int            GL_APIENTRY glGetAttribLocation (GLuint program, const GLchar* name)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetBooleanv (GLenum pname, GLboolean* params);
    GL_API void           GL_APIENTRY glGetBufferParameteriv (GLenum target, GLenum pname, GLint* params);
    GL_API GLenum         GL_APIENTRY glGetError (void);
    GL_API void           GL_APIENTRY glGetFloatv (GLenum pname, GLfloat* params);
    GL_API void           GL_APIENTRY glGetFramebufferAttachmentParameteriv (GLenum target, GLenum attachment, GLenum pname, GLint* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetIntegerv (GLenum pname, GLint* params);
    GL_API void           GL_APIENTRY glGetProgramiv (GLuint program, GLenum pname, GLint* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetProgramInfoLog (GLuint program, GLsizei bufsize, GLsizei* length, GLchar* infolog)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetRenderbufferParameteriv (GLenum target, GLenum pname, GLint* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetShaderiv (GLuint shader, GLenum pname, GLint* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetShaderInfoLog (GLuint shader, GLsizei bufsize, GLsizei* length, GLchar* infolog)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetShaderPrecisionFormat (GLenum shadertype, GLenum precisiontype, GLint* range, GLint* precision)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetShaderSource (GLuint shader, GLsizei bufsize, GLsizei* length, GLchar* source)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API const GLubyte* GL_APIENTRY glGetString (GLenum name);
    GL_API void           GL_APIENTRY glGetTexParameterfv (GLenum target, GLenum pname, GLfloat* params);
    GL_API void           GL_APIENTRY glGetTexParameteriv (GLenum target, GLenum pname, GLint* params);
    GL_API void           GL_APIENTRY glGetUniformfv (GLuint program, GLint location, GLfloat* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetUniformiv (GLuint program, GLint location, GLint* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API int            GL_APIENTRY glGetUniformLocation (GLuint program, const GLchar* name)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetVertexAttribfv (GLuint index, GLenum pname, GLfloat* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetVertexAttribiv (GLuint index, GLenum pname, GLint* params)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glGetVertexAttribPointerv (GLuint index, GLenum pname, GLvoid** pointer)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glHint (GLenum target, GLenum mode);
    GL_API GLboolean      GL_APIENTRY glIsBuffer (GLuint buffer);
    GL_API GLboolean      GL_APIENTRY glIsEnabled (GLenum cap);
    GL_API GLboolean      GL_APIENTRY glIsFramebuffer (GLuint framebuffer)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API GLboolean      GL_APIENTRY glIsProgram (GLuint program);
    GL_API GLboolean      GL_APIENTRY glIsRenderbuffer (GLuint renderbuffer)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API GLboolean      GL_APIENTRY glIsShader (GLuint shader)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API GLboolean      GL_APIENTRY glIsTexture (GLuint texture);
    GL_API void           GL_APIENTRY glLineWidth (GLfloat width);
    GL_API void           GL_APIENTRY glLinkProgram (GLuint program)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glPixelStorei (GLenum pname, GLint param);
    GL_API void           GL_APIENTRY glPolygonOffset (GLfloat factor, GLfloat units);
    GL_API void           GL_APIENTRY glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid* pixels);
    GL_API void           GL_APIENTRY glReleaseShaderCompiler (void)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glRenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glSampleCoverage (GLclampf value, GLboolean invert);
    GL_API void           GL_APIENTRY glScissor (GLint x, GLint y, GLsizei width, GLsizei height);
    GL_API void           GL_APIENTRY glShaderBinary (GLsizei n, const GLuint* shaders, GLenum binaryformat, const GLvoid* binary, GLsizei length)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glShaderSource (GLuint shader, GLsizei count, const GLchar* const *string, const GLint* length)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glStencilFunc (GLenum func, GLint ref, GLuint mask);
    GL_API void           GL_APIENTRY glStencilFuncSeparate (GLenum face, GLenum func, GLint ref, GLuint mask)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glStencilMask (GLuint mask);
    GL_API void           GL_APIENTRY glStencilMaskSeparate (GLenum face, GLuint mask)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glStencilOp (GLenum fail, GLenum zfail, GLenum zpass);
    GL_API void           GL_APIENTRY glStencilOpSeparate (GLenum face, GLenum fail, GLenum zfail, GLenum zpass)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid* pixels);
    GL_API void           GL_APIENTRY glTexParameterf (GLenum target, GLenum pname, GLfloat param);
    GL_API void           GL_APIENTRY glTexParameterfv (GLenum target, GLenum pname, const GLfloat* params);
    GL_API void           GL_APIENTRY glTexParameteri (GLenum target, GLenum pname, GLint param);
    GL_API void           GL_APIENTRY glTexParameteriv (GLenum target, GLenum pname, const GLint* params);
    GL_API void           GL_APIENTRY glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid* pixels);
    GL_API void           GL_APIENTRY glUniform1f (GLint location, GLfloat x)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform1fv (GLint location, GLsizei count, const GLfloat* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform1i (GLint location, GLint x)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform1iv (GLint location, GLsizei count, const GLint* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform2f (GLint location, GLfloat x, GLfloat y)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform2fv (GLint location, GLsizei count, const GLfloat* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform2i (GLint location, GLint x, GLint y)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform2iv (GLint location, GLsizei count, const GLint* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform3f (GLint location, GLfloat x, GLfloat y, GLfloat z)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform3fv (GLint location, GLsizei count, const GLfloat* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform3i (GLint location, GLint x, GLint y, GLint z)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform3iv (GLint location, GLsizei count, const GLint* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform4f (GLint location, GLfloat x, GLfloat y, GLfloat z, GLfloat w)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform4fv (GLint location, GLsizei count, const GLfloat* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform4i (GLint location, GLint x, GLint y, GLint z, GLint w)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniform4iv (GLint location, GLsizei count, const GLint* v)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat* value)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glUseProgram (GLuint program)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glValidateProgram (GLuint program)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib1f (GLuint indx, GLfloat x)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib1fv (GLuint indx, const GLfloat* values)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib2f (GLuint indx, GLfloat x, GLfloat y)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib2fv (GLuint indx, const GLfloat* values)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib3f (GLuint indx, GLfloat x, GLfloat y, GLfloat z)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib3fv (GLuint indx, const GLfloat* values)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib4f (GLuint indx, GLfloat x, GLfloat y, GLfloat z, GLfloat w)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttrib4fv (GLuint indx, const GLfloat* values)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    GL_API void           GL_APIENTRY glViewport (GLint x, GLint y, GLsizei width, GLsizei height);
    
#endif




#endif//CC_PLATFORM_IOS_METAL
#endif // CC_PLATFORM_IOS
