# Hello Shader

# Shaderとは

## Types of shader

Unityでは、シェーダーは大きく3つのカテゴリーに分かれています。それぞれのカテゴリーは、異なる目的のために使用され、作業方法も異なります。

- シェーダーの中でも最も一般的なのが、グラフィックスパイプラインに組み込まれたシェーダーです。画面上のピクセルの色を決定する計算を行います。画面上のピクセルの色を決定する計算を行います。Unityでは通常、**ShaderObject**を使ってこのタイプのシェーダーを扱います。
- **ComputeShade**rは、通常のグラフィックスパイプラインの外で、GPU上で計算を行います。
- **Ray tracing shader**は、レイトレーシングに関連する計算を行います。

## ShaderGraph　Or Shader program

![Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/maxresdefault.jpg](Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/maxresdefault.jpg)

[Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/93f407_d007d8f79659497bbe0e095d1d1b78b3_mv2.webp](Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/93f407_d007d8f79659497bbe0e095d1d1b78b3_mv2.webp)

# CrossShaderをみてみよう

## Cross Section Asset

[https://assetstore.unity.com/packages/vfx/shaders/cross-section-66300](https://assetstore.unity.com/packages/vfx/shaders/cross-section-66300)

```csharp
bool checkVisability(fixed3 worldPos)
{
  float dotProd1 = dot(worldPos - _PlanePosition, _PlaneNormal);
  return dotProd1 >0 ;
}
```

![Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/crvE6.png](Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/crvE6.png)

![Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/images.png](Hello%20Shader%206d1e8eaf0f4d4f9d860f2a4f02a95714/images.png)

# Shader programを書いてみよう

## １．一番簡単なShader

```csharp
Shader "GEL/MyFirstShader"
{
    Properties
    {
        _myColor ("Example Color", Color) = (1,1,1,1)

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

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            o.Albedo = _myColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
```

```csharp
Shader "GEL/MyFirstShader"
{
    Properties
    {
        _myColor ("Example Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
        };

        float4 _myColor;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Emission = _myColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
```

```csharp
void surf (Input IN, inout SurfaceOutputStandard o)
        {

            o.Emission= _myColor.rgb;
        }
```

## Emission & Albedo

```csharp
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
```

## SurfaceOutputStandard

```csharp
struct SurfaceOutputStandard
{
    fixed3 Albedo;      // base (diffuse or specular) color
    float3 Normal;      // tangent space normal, if written
    half3 Emission;
    half Metallic;      // 0=non-metal, 1=metal
    // Smoothness is the user facing name, it should be perceptual smoothness but user should not have to deal with it.
    // Everywhere in the code you meet smoothness it is perceptual smoothness
    half Smoothness;    // 0=rough, 1=smooth
    half Occlusion;     // occlusion (default 1)
    fixed Alpha;        // alpha for transparencies
};
```

## Packed Array

```csharp
o.Albedo.rg = _myColor.xy;
```

## struct Input

```csharp
struct Input{
	float2 uv_MainTex;
}
```

```csharp
struct Input{
	float3 viewDir;
}
```

```csharp
struct Input{
	float3 worldPos;
}
```

```csharp
struct Input{
	float3 worldRefl;
}
```

```csharp
struct Input{
	float2 uv_MainTex;
	float3 viewDir;
	float3 worldRefl;
}
```

公式Unityページより

Additional values that can be put into Input structure:

- `float3 viewDir` - contains view direction, for computing Parallax effects, rim lighting etc.
- `float4` with `COLOR` semantic - contains interpolated per-vertex color.
- `float4 screenPos` - contains screen space position for reflection or screenspace effects. Note that this is not suitable for [GrabPass](https://docs.unity3d.com/Manual/SL-GrabPass.html); you need to compute custom UV yourself using `ComputeGrabScreenPos` function.
- `float3 worldPos` - contains world space position.
- `float3 worldRefl` - contains world reflection vector *if surface shader does not write to o.Normal*. See Reflect-Diffuse shader for example.
- `float3 worldNormal` - contains world normal vector *if surface shader does not write to o.Normal*.
- `float3 worldRefl; INTERNAL_DATA` - contains world reflection vector *if surface shader writes to o.Normal*. To get the reflection vector based on per-pixel **normal map**, use `WorldReflectionVector (IN, o.Normal)`. See Reflect-Bumped shader for example.
- `float3 worldNormal; INTERNAL_DATA` - contains world normal vector *if surface shader writes to o.Normal*. To get the normal vector based on per-pixel normal map, use `WorldNormalVector (IN, o.Normal)`.

[Writing Surface Shaders](https://docs.unity3d.com/Manual/SL-SurfaceShaders.html)

## Textureを使おう！

[Textures for 3D, graphic design and Photoshop!](https://www.textures.com/)

```csharp
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
```

## 条件付けしてみよう

```csharp
Shader "GEL/MyThirdShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
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
    }
    FallBack "Diffuse"
}
```
