//Written by |copiSACH_et
//RT's luminance will be converted into night vision's color. Additional effect such as depth and white noise
//is added.

Shader "Sachet/Filter/NightVision"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _BaseMap ("Base Map", 2D) = "white"
        _LuminanceMultiplier ("Luminance Multiplier", Float) = 0.0
        _StepBias("Step Bias", Float) = 0.0
        _NoiseAdder("Noise Multiplier", Float) = 0.0
    }
    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                //#define PI 3.1415926535897932384626433832795

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

            // UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            // #define SampleDepthTexture(uv) (SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv/uv.w))

            TEXTURE2D(_CameraDepthTexture);
            SAMPLER(sampler_CameraDepthTexture);

            CBUFFER_START(UnityPerMaterial)
                half4 _Color;
                float4 _BaseMap_ST;
                float _LuminanceMultiplier;
                float _StepBias;
                float _NoiseAdder;
            CBUFFER_END

            float Luminance(float3 color)
            {
                return dot(color, float3(0.299, 0.587, 0.114));
            }

            //From Ronja's article about white noise
            //Returns random value from 0 to 1 with normalized value input
            float WhiteNoise(float2 value)
            {
                //make value smaller to avoid artefacts
                float2 smallValue;
                smallValue.x = sin(value.x * _Time.y);
                smallValue.y = sin(value.y * _Time.y);
                //get scalar value from 3d vector
                float random = dot(smallValue, float2(12.9898, 78.233));
                //make value more random by making it bigger and then taking teh factional part
                random = frac(sin(random) * 143758.5453);
                return random;
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
                float l = Luminance(sampledColor.rgb) * clamp(_LuminanceMultiplier, 0, 1);
                float noiseVal = WhiteNoise(IN.uv)+_NoiseAdder;
                l *= noiseVal;
                l = smoothstep(0,_StepBias,clamp(l, 0, 1));
                half4 colorOut = half4(0,l,0,1);
                return colorOut;
            }
            ENDHLSL
        }
    }
}