Shader "GEL/MySecondShader"
{
    Properties
    {
        _myColor("Example Color", Color) = (1,1,1,1)
        _myRange("Example Range", Range(0,3)) = 1
        _myCube("Example Cube", CUBE) = ""{}
        _myTex("Example 2D", 2D) = "Blue"{}
        _myBump("Example Bump", 2D) = "Blue"{}
        _myVector("Example Vector", Vector) = (0,0,0,0)
        _myFloat("Example Float", Float) = 0.5
        _myTex3d("Example 3D", 3D) = "white"{}
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        fixed4 _myColor;
        sampler2D _MainTex;
        half _myRange;
        sampler2D _myTex;
        sampler2D _myBump;
        samplerCUBE _myCube;
        float _myFloat;
        float4 _myVector;
        

        struct Input
        {
            float2 uv_myTex;
            float2 uv_myBump;
            float3 worldRefl;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_myTex, IN.uv_myTex) * _myColor;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump))*float3(_myRange,_myRange,1); 
            // Metallic and smoothness come from slider variables
            //o.Metallic = _myMetallic;
            //o.Smoothness = _myGlossiness;
            o.Alpha = _myRange;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
