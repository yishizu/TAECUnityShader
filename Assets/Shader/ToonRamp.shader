Shader "GEL/ToonRamp"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex("Ramp Tex", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf ToonRamp

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        fixed4 _Color;

        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            float h = diff*0.5 + 0.5;
            float rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            //c.rgb = s.Albedo *_LightColor0.rgb *(ramp);
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb *(ramp)) * atten * _SinTime*10.0;
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float diff = dot (o.Normal, IN.viewDir);
			float h = diff * 0.5 + 0.5;
			float2 rh = h;
			o.Albedo = tex2D(_RampTex, rh).rgb*_Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
