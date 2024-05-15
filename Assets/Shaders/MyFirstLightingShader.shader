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

            struct Interpolators {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexData {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST; // For Tiling and Offset controls

            Interpolators MyVertexProgram(VertexData v) { //: SV_POSITION  // SV = System Value, POSITION = final vertex position
                Interpolators i;
                //i.localPosition = v.position.xyz; // could also use position.rgb
                i.position = UnityObjectToClipPos(v.position);
                //i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return i;
            }

            float4 MyFragmentProgram(Interpolators i) : SV_TARGET { // Outputs an RGBA color val for one pixel // SV_TARGET = frame buffer
                return tex2D(_MainTex, i.uv) * _Tint; //float4(i.uv, 1, 1); // Alpha val gets ignored by the shader because there is no support for transparency written here yet, so 0 here doesn't affect it
            }

            ENDCG // Terminate code with ENDCG
            
        }
    }
}