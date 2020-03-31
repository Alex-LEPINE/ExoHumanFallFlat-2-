Shader "Custom/Standard Ice Glitter" {
	Properties {

		_Fresnel ("Edge", Range(0,3)) = 0.5
		_EFresnel (" Emission Edge", Range(0,3)) = 0.5

		_Color ("Core Color", Color) = (1,1,1,1)
		_EdgeColor ("Edge Color", Color) = (1,1,1,1)

		_Emission ("Core Emission", Color) = (0,0,0,1)
		_EdgeEmission ("Edge Emission", Color) = (0,0,0,1)
		
		_Glitter ("Glitter texture", 2D) = "black" {}
		_Scale ("Glitter Scale", Range(0,5)) = 1

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_BumpMap ("Normal", 2D) = "bump" {}

		}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.5

		sampler2D _Glitter;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_Glitter;
			float3 viewDir;
			float4 screenPos;
		};

		half _Glossiness,  _Metallic, _Scale, _Fresnel, _EFresnel;
		fixed4 _Emission, _EdgeEmission, _Color, _EdgeColor;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)


		void surf (Input IN, inout SurfaceOutputStandard o) {

		//Fresnel////////////////
		float3 normal = UnpackNormal (tex2D (_BumpMap, IN.uv_Glitter));
		half factor = dot(normalize(IN.viewDir),o.Normal);

		float fresnel = saturate((_Fresnel-factor*_Fresnel));
		float eFresnel = saturate((_EFresnel-factor*_EFresnel));
			// Albedo comes from a texture tinted by color
			fixed4 c = lerp(_Color,_EdgeColor,fresnel);
			fixed4 s = tex2D (_Glitter, IN.uv_Glitter * _Scale);
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			screenUV *= float2(8,6) + IN.viewDir.rg;
			float f = tex2D (_Glitter, screenUV).b;
			fixed3 glitter = 0;
			glitter.rg = s;
			float g = lerp(glitter.r,glitter.g, f);
			o.Albedo = c + g;

			o.Emission = lerp(_Emission,_EdgeEmission,eFresnel);
			 o.Emission += (g * 0.2); 

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness * fresnel;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
