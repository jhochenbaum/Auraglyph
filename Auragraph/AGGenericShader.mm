//
//  AGGenericShader.mm
//  Auragraph
//
//  Created by Spencer Salazar on 8/16/13.
//  Copyright (c) 2013 Spencer Salazar. All rights reserved.
//

#import "AGGenericShader.h"
#import "ShaderHelper.h"


static AGGenericShader *g_shader = NULL;

AGGenericShader &AGGenericShader::instance()
{
    if(g_shader ==  NULL) g_shader = new AGGenericShader();
    
    return *g_shader;
}

AGGenericShader::AGGenericShader(NSString *name)
{
    m_program = [ShaderHelper createProgram:name
                             withAttributes:SHADERHELPER_ATTR_POSITION | SHADERHELPER_ATTR_NORMAL | SHADERHELPER_ATTR_COLOR];
    m_uniformMVPMatrix = glGetUniformLocation(m_program, "modelViewProjectionMatrix");
    m_uniformNormalMatrix = glGetUniformLocation(m_program, "normalMatrix");
    
    m_proj = GLKMatrix4Identity;
    m_mv = GLKMatrix4Identity;
}

void AGGenericShader::useProgram()
{
    glUseProgram(m_program);
}

void AGGenericShader::setProjectionMatrix(const GLKMatrix4 &p)
{
    m_proj = p;
    glUniformMatrix4fv(m_uniformMVPMatrix, 1, 0, GLKMatrix4Multiply(m_proj, m_mv).m);
}

void AGGenericShader::setModelViewMatrix(const GLKMatrix4 &mv)
{
    m_mv = mv;
    glUniformMatrix4fv(m_uniformMVPMatrix, 1, 0, GLKMatrix4Multiply(m_proj, m_mv).m);
}

void AGGenericShader::setMVPMatrix(const GLKMatrix4 &mvpm)
{
    glUniformMatrix4fv(m_uniformMVPMatrix, 1, 0, mvpm.m);
}

void AGGenericShader::setNormalMatrix(const GLKMatrix3 &nm)
{
    glUniformMatrix3fv(m_uniformNormalMatrix, 1, 0, nm.m);
}


static AGClipShader *g_clipShader = NULL;

AGClipShader &AGClipShader::instance()
{
    if(g_clipShader ==  NULL) g_clipShader = new AGClipShader();
    
    return *g_clipShader;
}

AGClipShader::AGClipShader() : AGGenericShader(@"Clip")
{
    m_uniformLocalMatrix = glGetUniformLocation(m_program, "localMatrix");
    m_uniformClipOrigin = glGetUniformLocation(m_program, "clipOrigin");
    m_uniformClipSize = glGetUniformLocation(m_program, "clipSize");
}

void AGClipShader::setClip(const GLvertex2f &origin, const GLvertex2f &size)
{
    glUniform2f(m_uniformClipOrigin, origin.x, origin.y);
    glUniform2f(m_uniformClipSize, size.x, size.y);
}

void AGClipShader::setLocalMatrix(const GLKMatrix4 &l)
{
    glUniformMatrix4fv(m_uniformLocalMatrix, 1, 0, l.m);
}



