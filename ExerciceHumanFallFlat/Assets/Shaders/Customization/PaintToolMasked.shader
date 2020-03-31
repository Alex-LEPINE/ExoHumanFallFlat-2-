// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "CharacterCustomize/PaintToolMasked"
{
	Properties
	{
		_ModelTex("Model (RGB)", 2D) = "white" {} // texture of the model before this stroke
		_MaskTex("Mas (RGB)", 2D) = "white" {} // mask texture
		_BaseTex("Base (RGB)", 2D) = "white" {} // previous texture of stroke
		_Color ("Color", Color) = (1,0,0,1) 
		_PointSize("Point size from height",Range(0,1)) = 0.05
		_FalloffSize("Faloff size from height",Range(0,1)) = 0.01
		_PointPos("Point position", Vector) = (512,200,0,0)
		_ScreenSize("Screen size", Vector) = (1024,768,0,0)
		_TexSize("Texture size", float) = 2048
		_Mask1("Mask1", Range(0,1)) = 1
		_Mask2("Mask2", Range(0,1)) = 1
		_Mask3("Mask3", Range(0,1)) = 1
		_PaintBackface("Paint backface",Range(0,1)) = 0
	}
	SubShader
	{
		Cull Off
		//Tags { "QUEUE"="Transparent" "RenderType"="Transparent"}
		//Tags { "Queue" = "Transparent" }

		LOD 100

		Pass
		{
			//Blend SrcAlpha OneMinusSrcAlpha, One One
			/*Blend Zero One, Zero One*/
			//Blend One Zero, One Zero
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 screen : TEXCOORD1;
				float4 pointData : TEXCOORD2;
				float3 normal : TEXCOORD3;
				float3 view : TEXCOORD4;
				
			};

			uniform float2 _ScreenSize;
			uniform float2 _PointPos;
			uniform float _PointSize;
			uniform float _FalloffSize;
			uniform float4 _Color;
			uniform float _PaintBackface;
			uniform float _Mask1;
			uniform float _Mask2;
			uniform float _Mask3;
			uniform float _TexSize;
			sampler2D _BaseTex;
			sampler2D _ModelTex;
			sampler2D _MaskTex;
			
			v2f vert (appdata v)
			{
				
				v2f o;
//#if defined(UNITY_HALF_TEXEL_OFFSET)
//				o.vertex = float4(v.uv * 2 - 1 - 1.0 / _TexSize, 0, 1); //D3D
//#else
				o.vertex = float4(v.uv * 2 - 1 , 0, 1); // OPENGL
//#endif

#if UNITY_UV_STARTS_AT_TOP
				o.vertex.y =-o.vertex.y;
#endif
#if defined(UNITY_HALF_TEXEL_OFFSET)
				o.vertex.xy -= 1.0 / _TexSize; //D3D
#endif
				o.uv = v.uv;
                o.screen = UnityObjectToClipPos (v.vertex);
				o.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
				float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.view = normalize(posWorld.xyz-_WorldSpaceCameraPos);

				o.pointData = float4(_PointPos.xy, _PointSize*_ScreenSize.y, _FalloffSize*_ScreenSize.y);
				return o;
			}

			struct f2s {
#if SHADER_API_PSSL
				fixed4 col0 : SV_Target0;
				fixed4 col1 : SV_Target1;
#else			
				fixed4 col0 : COLOR0;
				fixed4 col1 : COLOR1;
#endif				
			};

			f2s frag (v2f i)
			{
				f2s fout;
				float2 screen = i.screen.xy / i.screen.w / 2 + 0.5;
#if UNITY_UV_STARTS_AT_TOP
				screen.y=1-screen.y;
#endif
				screen*=_ScreenSize;


				float2 pointPos = i.pointData.xy;
				float size= i.pointData.z;
				float falloff= i.pointData.w;

				
				// calculate alpha from distance from point
				float dist = length(screen - pointPos);
				float alpha = smoothstep(size+falloff,size,dist);

				// backface culling
				float3 normalDir = normalize(i.normal);
				float3 viewDir = normalize(i.view); 
				float nv = dot(normalDir, viewDir);
				alpha *= max(smoothstep(-0.01,0.01,-nv), _PaintBackface);

				float4 col = _Color;
				col.a *=alpha;

				// blend with base
				fixed4 baseTex = tex2D(_BaseTex, i.uv);
				//baseTex.a = pow(baseTex.a, 2.2);

#if SHADER_API_PSSL
				col.rgb = lerp(baseTex.rgb, col.rgb, col.aaa);
#else
				col.rgb = lerp(baseTex, col.rgb, col.a);
#endif				
				col.a = baseTex.a*(1 - col.a) + col.a;


				// blend with model
				fixed4 modelTex = tex2D(_ModelTex, i.uv);
				fixed4 maskTex = tex2D(_MaskTex, i.uv);
				float blend = clamp(maskTex.r*_Mask1 + maskTex.g*_Mask2 + maskTex.b*_Mask3,0,1);



				fout.col0 = modelTex*(1 - col.a*blend) + col*blend;
				fout.col1 = col;
				
				
				return fout;
			}
			ENDCG
		}
	}
}
