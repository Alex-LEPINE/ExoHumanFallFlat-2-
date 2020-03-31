Shader "CharacterCustomize/ShowMask" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_MaskTex("Mask (RGB)", 2D) = "white" {} // mask texture
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Mask1("Mask1", Range(0,1)) = 1
		_Mask2("Mask2", Range(0,1)) = 1
		_Mask3("Mask3", Range(0,1)) = 1

	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		//Tags{ "LightMode" = "ForwardBase" }
		//LOD 200
		//ZWrite off
		//Offset 0,-10   //THIS IS THE ADDED LINE

		CGPROGRAM
	

			
		sampler2D _MainTex;
		sampler2D _MaskTex;
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		uniform float _Mask1;
		uniform float _Mask2;
		uniform float _Mask3;

			#pragma surface surf Standard alphatest:_Cutout vertex:myvert 


		struct Input {
			float2 uv_MainTex;
			float4 screenPos;

		};

		void myvert(inout appdata_full v, out Input data) {
			UNITY_INITIALIZE_OUTPUT(Input, data);
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;

			float2 screenUV = IN.screenPos.xy / (0.00000000001+ IN.screenPos.w);
			screenUV *= float2(1.6, .9);


			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			fixed4 maskTex = tex2D(_MaskTex, IN.uv_MainTex);
			float blend = clamp(maskTex.r*_Mask1 + maskTex.g*_Mask2 + maskTex.b*_Mask3, 0, 1);


			o.Albedo = lerp(c.rgb,(sin((screenUV.x + screenUV.y) * 200 + _Time.y * 5) + 1) / 2, (1-blend)*0.33);

		}
		ENDCG
		}

			Fallback "Diffuse"
}
