Shader "GEL/MyFirstShader"
{
    Properties
    {
        _myColor ("Example Color", Color) = (1,1,1,1)
        _myEmission ("Example Emission", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
        };

        float4 _myColor;
        float4 _myEmission;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            o.Albedo = _myColor.rgb;
            o.Emission = _myEmission.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
