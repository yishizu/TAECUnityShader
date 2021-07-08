Shader "GEL/MyThirdShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    	_CrossColor("Cross Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _PlaneNormal("PlaneNormal",Vector) = (0,1,0,0)
		_PlanePosition("PlanePosition",Vector) = (0,0,0,1)
        
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

        sampler2D _MainTex;
        fixed3 _PlaneNormal;
		fixed3 _PlanePosition;
        fixed4 _Color;
        

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        bool checkVisability(fixed3 worldPos)
		{
			float dotProd1 = dot(worldPos - _PlanePosition, _PlaneNormal);
			return dotProd1 > 0  ;
		}

        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            if (checkVisability(IN.worldPos))discard;
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
 
        }
        ENDCG
    	
    	Cull Front
    	CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf NoLighting noambient



        sampler2D _MainTex;
        fixed3 _PlaneNormal;
		fixed3 _PlanePosition;
        fixed4 _CrossColor;
        

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        bool checkVisability(fixed3 worldPos)
		{
			float dotProd1 = dot(worldPos - _PlanePosition, _PlaneNormal);
			return dotProd1 > 0  ;
		}

    	fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            if (checkVisability(IN.worldPos))discard;
			o.Albedo = _CrossColor;
 
        }
        ENDCG
    }
    FallBack "Diffuse"
}
