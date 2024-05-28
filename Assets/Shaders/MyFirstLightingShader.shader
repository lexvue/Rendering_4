Shader "Unlit/MyFirstLightingShader"
{
    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    // Can use these to group multiple shader variants together
    SubShader { 
        // Must contain at least one Pass, this is where an object actually gets rendered
        // Having more than one Pass means that the object gets rendered multiple times -> good for a lot of effects

        Pass {

            Tags {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM  // Start of Unity Shading Language. Have to start with CGPROGRAM 

            #pragma vertex MyVertexProgram // For Mesh Vertices and Transformation Matrix (vertex data of a mesh, object space -> display space)
            #pragma fragment MyFragmentProgram // For Transformed vertices from MyVertexProgram and Mesh Triangles (coloring pixels in a mesh's triangle)

            #include "UnityStandardBRDF.cginc" // for DotClamped and UnityCD.cginc

            struct VertexData {
                float4 position : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST; // For Tiling and Offset controls

            Interpolators MyVertexProgram(VertexData v) {
                Interpolators i;
                i.position = UnityObjectToClipPos(v.position);
                i.normal = UnityObjectToWorldNormal(v.normal);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return i;
            } 

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET {
                i.normal = normalize(i.normal);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb;
                float3 diffuse = lightColor * DotClamped(lightDir, i.normal)
                return float4(diffuse, 1); // most shaders use saturate instead. clamps between 0 and 1
            }

            ENDCG // Terminate code with ENDCG
            
        }
    }
}