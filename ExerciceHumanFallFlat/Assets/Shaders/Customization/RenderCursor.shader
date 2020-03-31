// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CharacterCustomize/RenderCursor"
{
	Properties
	{
		_Color ("Color", Color) = (1,0,0,1) 
		_PointSize("Point size from height",Range(0,1)) = 0.05
		_FalloffSize("Faloff size from height",Range(0,1)) = 0.01
		_PointPos("Point position", Vector) = (512,200,0,0)
		_ScreenSize("Screen size", Vector) = (1024,768,0,0)
	}
	SubShader
	{
		Cull Off
		//Tags { "QUEUE"="Transparent" "RenderType"="Transparent"}
		Tags { "Queue" = "Transparent" }

		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 screen : TEXCOORD1;
				float4 pointData : TEXCOORD2;
			};

			uniform float2 _ScreenSize;
			uniform float2 _PointPos;
			uniform float _PointSize;
			uniform float _FalloffSize;
			uniform float4 _Color;

			
			v2f vert (appdata v)
			{
				
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screen = UnityObjectToClipPos (v.vertex);
				o.pointData = float4(_PointPos.xy, _PointSize*_ScreenSize.y, _FalloffSize*_ScreenSize.y);
		#if UNITY_UV_STARTS_AT_TOP
        		o.screen.y = 1.0 - o.screen.y;
        #endif
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				float2 screen = i.screen.xy/i.screen.w/2+0.5;
				//screen.y=1-screen.y;
// imprecision, not sure why?
#if UNITY_UV_STARTS_AT_TOP
				screen.y-=.005; 
#endif
				screen*=_ScreenSize;
				
				
				//float2 screen =i.vertex.xy;
				//screen.y = _ScreenSize.y-screen.y;

				float2 pointPos = i.pointData.xy;
				float size= i.pointData.z;
				float falloff= i.pointData.w;

				float antialias = 0.002*_ScreenSize.y;

				float dist = length(screen - pointPos);
				float alpha = smoothstep(size+falloff+antialias,size,dist) 
					* smoothstep(size-antialias,size,dist);
				float4 col = _Color;
				col.a *=alpha;
				
				return col;
			}
			ENDCG
		}
	}
}
