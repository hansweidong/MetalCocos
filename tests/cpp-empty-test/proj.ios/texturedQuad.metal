/*
 <samplecode>
 <abstract>
 Textured quad shader.
 </abstract>
 </samplecode>
 */

#include <metal_graphics>
#include <metal_matrix>
#include <metal_geometric>
#include <metal_math>
#include <metal_texture>

using namespace metal;

struct Vertex
{
    packed_float3 position;
    packed_uchar4 color;
    packed_float2 texcoord;
};

struct VertexInOut
{
    float4 m_Position [[position]];
    float2 m_TexCoord [[user(texturecoord)]];
    half4 color;
};

vertex VertexInOut texturedQuadVertex(const device Vertex *pos_data [[buffer(0)]]
                                      ,constant float4x4       *pMVP        [[ buffer(1) ]]
                                      ,uint                     vid         [[ vertex_id ]]
                                      )
{
    VertexInOut outVertices;
    Vertex vData = pos_data[vid];
    
    float4 pos = float4(float3(vData.position), 1);
    float2 texcoord = float2(vData.texcoord);
    float4 color = float4(vData.color[0]/255.0f, vData.color[1]/255.0f, vData.color[2]/255.0f, vData.color[3]/255.0f);
    
#if 0
    float4x4 mvp;
    mvp[0] = {1.15470064f, 0, 0, 0};
    mvp[1] = {0, 1.7320509f, 0, 0};
    mvp[2] = {0, 0, -1.04687428f, -1};
    mvp[3] = {-277.128143f, -277.128143f, 269.173096f, 276.673004f};
    outVertices.m_Position = mvp * pos;
#else
    outVertices.m_Position = *pMVP * pos;
#endif
    outVertices.m_TexCoord = texcoord;
    outVertices.color = half4(color);
    
    return outVertices;
}

fragment half4 texturedQuadFragment(VertexInOut     inFrag    [[ stage_in ]]
                                    ,texture2d<half>  tex2D     [[ texture(0) ]]
                                    )
{
    constexpr sampler quad_sampler;
    half4 color = tex2D.sample(quad_sampler, inFrag.m_TexCoord) * inFrag.color;
    return color;
}
