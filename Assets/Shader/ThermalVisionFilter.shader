//Written by |copiSACH_et
//Any visible ambient temperature map will be converted into general thermal vision's color

Shader "Sachet/Filter/ThermalVision"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _BaseMap ("Base Map", 2D) = "white"
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                // The positionOS variable contains the vertex positions in object
                // space.
                float4 positionOS   : POSITION; 
                float2 uv           : TEXCOORD0;                
            };

            struct Varyings
            {
                // The positions in this struct must have the SV_POSITION semantic.
                float4 positionHCS  : SV_POSITION;
                float2 uv           : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _Color;
                float4 _BaseMap_ST;
            CBUFFER_END

            float Luminance(float3 color)
            {
                return dot(color, float3(0.299f, 0.587f, 0.114f));
            }

            Varyings vert(Attributes IN)
            {
                // Declaring the output object (OUT) with the Varyings struct.
                Varyings OUT;
                // The TransformObjectToHClip function transforms vertex positions
                // from object space to homogenous space
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                // Returning the output.
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 sampledColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
                half4 colorOut;
                
                //Citation needed
                //From a certain forum discussing a thermal vision color range equation
                colorOut.r = sqrt(Luminance(sampledColor.rgb));
                colorOut.g = pow(Luminance(sampledColor.rgb),3);
                if(sin(2 * PI * Luminance(sampledColor.rgb)) >= 0)
                {
                    colorOut.b = sin(2 * PI * Luminance(sampledColor.rgb));
                }
                else
                {
                    colorOut.b = 0;
                }
                colorOut.a = 1;
                return colorOut;
            }
            ENDHLSL
        }
    }
}