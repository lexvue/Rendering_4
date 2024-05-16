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
            CGPROGRAM  // Start of Unity Shading Language. Have to start with CGPROGRAM 

            #pragma vertex MyVertexProgram // For Mesh Vertices and Transformation Matrix (vertex data of a mesh, object space -> display space)
            #pragma fragment MyFragmentProgram // For Transformed vertices from MyVertexProgram and Mesh Triangles (coloring pixels in a mesh's triangle)

            #include "UnityCG.cginc" // UnityCG -> UnityInstancing -> UnityShaderVariables -> HLSLSupport

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
                /*
                i.normal = mul(
                    transpose((float3x3)unity_ObjectToWorld), 
                    v.normal
                );
                i.normal = normalize(i.normal);
                */
                i.normal = UnityObjectToWorldNormal(v.normal);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return i;
            } 

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET {
                // The amount of diffused light is directly proportional to the cosine of the angle between the light 
                // direction and the surface normal. This is known as Lambert's cosine law
                i.normal = normalize(i.normal);
                // return max(0, dot(float3(0, 1, 0), i.normal)); // clamping because we don't want negative light 
                return saturate(dot(float3(0, 1, 0), i.normal)); // most shaders use saturate instead. clamps between 0 and 1
            }

            ENDCG // Terminate code with ENDCG
            
        }
    }
}