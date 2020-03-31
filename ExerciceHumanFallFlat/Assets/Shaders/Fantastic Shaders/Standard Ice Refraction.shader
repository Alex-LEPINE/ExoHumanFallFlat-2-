Shader "Human/Standard Ice Refraction" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Normal", 2D) = "bump" {}
		_Distort ("Distortion Strength", Range(0,2)) = 1
		_Glossiness ("Smoothness", Range(0.01,1)) = 0.5
		_Metallic ("Metallic", Range(0.01,1)) = 0.0
		_Extra ("Emission Boost", Range(0.01,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		//ZWrite Off
		GrabPass{"_GrabTexture"}
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting


		struct Input {
			float2 uv_MainTex;
			float2 uv2_BumpMap;
			float4 screenPos;
			float3 normal;
			INTERNAL_DATA
		};

		#pragma target 3.5
		
		 void vert  (inout appdata_full v, out Input o) {
			 UNITY_INITIALIZE_OUTPUT(Input,o);
			o.screenPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
			o.normal = normalize(mul((float3x3)UNITY_MATRIX_MV, v.normal));
		}
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _GrabTexture;
		half _Glossiness;
		half _Metallic;
		half _Extra;
		fixed4 _Color;
		float _Distort;
		sampler2D_float _CameraDepthTexture;
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			//o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv2_BumpMap));
			screenUV += ((UnpackNormal (tex2D (_BumpMap, IN.uv2_BumpMap)) * 1) + IN.normal )* _Distort;
			screenUV *= 1.05;
			//screenUV.x *= 2;
			//screenUV *= float2(8,6);
			float4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float3 x = tex2D (_GrabTexture, screenUV).rgb;

			o.Albedo.rgb = lerp(x,c.rgb,c.a);

			//o.Albedo.rgb = c.rgb;
			//o.Albedo.rgb = x + c.rgb;

			//o.Albedo.b = 0.5;

			//o.Albedo = IN.normal;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Emission = o.Albedo.rgb * _Extra;//x * (1-c.a);
			o.Alpha = _Color.a;
		
		}
		ENDCG
	}
	FallBack "Diffuse"
}
