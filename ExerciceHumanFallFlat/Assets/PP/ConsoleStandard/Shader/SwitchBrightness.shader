Shader "Console/SwitchBrightness" {
	Properties {
		_MainTex ("-", 2D) = "white" {}
		_Brightness ("Brightness",float) = 1.0
	}
	SubShader {
		Pass {
			ZTest Always Cull Off ZWrite Off
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform half _Brightness;

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
		};
		
		float4 _MainTex_ST;
		
		v2f vert (appdata_img v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos (v.vertex);
			
			o.uv = v.texcoord.xy;
			
			return o;
		}

		half4 frag (v2f i) : SV_Target
		{
			return tex2D(_MainTex, i.uv) * _Brightness;
		}
		
		ENDCG
		}
	} 
	FallBack Off
}

