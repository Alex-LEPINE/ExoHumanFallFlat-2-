Shader "Custom/HumanMetallic" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	_MetallicGlossMap("Metallic", 2D) = "white" {}
	_GlossMapScale("Smoothness", Range(0,1)) = 0.5
		_MetallicFactor("Metallic Factor",Range(0, 1)) = 1
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Cutout("Cutout", Range(0,1)) = 0.5
		_ClipDist("ClipDist", Range(0,5)) = 1
	}
		SubShader{
		//Tags{ "LightMode" = "ForwardBase" }
		//LOD 200
		//ZWrite off
		//Offset 0,-10   //THIS IS THE ADDED LINE

		CGPROGRAM



		sampler2D _MainTex;
	sampler2D _MetallicGlossMap;
	float _ClipDist;
	float _GlossMapScale;
	float _MetallicFactor;
	half _Glossiness;
	half _Metallic;
	fixed4 _Color;


#pragma surface surf Standard alphatest:_Cutout vertex:myvert 


	struct Input {
		float2 uv_MainTex;
		float4 screenPos;
		//half alpha;

	};

	void myvert(inout appdata_full v, out Input data) {
		UNITY_INITIALIZE_OUTPUT(Input, data);
		//float pos = length(UnityObjectToViewPos(v.vertex).xyz)*2-.5;
		//float pos = saturate(-mul(UNITY_MATRIX_MV, v.vertex).z*2-1);// UnityObjectToViewPos(v.vertex).xyz) * 2 - .5;
		float pos = saturate(length(mul(UNITY_MATRIX_MV, v.vertex).xyz) * 3 - 1.5f);// UnityObjectToViewPos(v.vertex).xyz) * 2 - .5;

																					//data.alpha = pos;
	}

	void surf(Input IN, inout SurfaceOutputStandard o) {
		half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		float2 screenUV = IN.screenPos.xy / (0.00000000001 + IN.screenPos.w);
		screenUV *= float2(160, 90);
		screenUV = frac(screenUV) * 2 - float2(1,1);
		o.Alpha = 1 - (screenUV.x*screenUV.x + screenUV.y*screenUV.y);
		//o.Alpha =  c.a*IN.alpha;
		o.Alpha += IN.screenPos.z * 2 - _ClipDist;
		fixed4 mc = tex2D(_MetallicGlossMap, IN.uv_MainTex);
		o.Metallic = mc.r * _MetallicFactor;
		o.Smoothness = mc.a * _GlossMapScale;
	}
	ENDCG
	}

		Fallback "Diffuse"
}
