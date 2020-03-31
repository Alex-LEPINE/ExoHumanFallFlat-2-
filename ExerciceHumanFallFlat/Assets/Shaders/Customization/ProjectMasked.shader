// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "CharacterCustomize/ProjectMasked"
{
	Properties
	{
		_ModelTex("Model (RGB)", 2D) = "white" {} // texture of the model before this stroke
		_MaskTex("Mask (RGB)", 2D) = "white" {} // mask texture
		_ProjectTex("Project (RGB)", 2D) = "white" {} // texture to project
		_ScreenSize("Screen size", Vector) = (1024,768,0,0)
		_TexSize("Texture size", float) = 2048
		_Mask1("Mask1", Range(0,1)) = 1
		_Mask2("Mask2", Range(0,1)) = 1
		_Mask3("Mask3", Range(0,1)) = 1
		_PaintBackface("Paint backface",Range(0,1)) = 0
		_MirrorMultiplier("Mirror Multiplier",Range(-1,1)) = 1
	}
	SubShader
	{
		Cull Off


		LOD 100

		Pass
		{

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

				float3 normal : TEXCOORD3;
				float3 view : TEXCOORD4;
				
			};

			uniform float2 _ScreenSize;

			uniform float _PaintBackface;
			uniform float _MirrorMultiplier;
			uniform float _Mask1;
			uniform float _Mask2;
			uniform float _Mask3;
			uniform int _TexSize;
			sampler2D _ProjectTex;
			sampler2D _ModelTex;
			sampler2D _MaskTex;
			
			v2f vert (appdata v)
			{
				
				v2f o;
				
#if defined(UNITY_HALF_TEXEL_OFFSET)
				o.vertex = float4(v.uv * 2 - 1 - 1.0 / _TexSize, 0, 1); //D3D
#else
				o.vertex = float4(v.uv * 2 - 1, 0, 1); // OPENGL
#endif


#if UNITY_UV_STARTS_AT_TOP
				o.vertex.y = -o.vertex.y;
#endif

				o.uv = v.uv;
                o.screen = UnityObjectToClipPos (v.vertex);
				o.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
				float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.view = normalize(posWorld.xyz-_WorldSpaceCameraPos);

				return o;
			}


			fixed4 frag (v2f i) : SV_Target
			{
				i.screen.x *= _MirrorMultiplier;
				float2 screen = i.screen.xy / i.screen.w / 2 + 0.5;
#if UNITY_UV_STARTS_AT_TOP
				screen.y = 1 - screen.y;
#endif


				// backface culling
				float3 normalDir = normalize(i.normal);
				float3 viewDir = normalize(i.view); 
				float nv = dot(normalDir, viewDir);
				float alpha = max(smoothstep(-0.01,0.01,-nv), _PaintBackface);

				fixed2 uvInside = step(0, screen) - step(1, screen);
				alpha *= uvInside.x*uvInside.y;
				//return alpha;

				float4 col = tex2D(_ProjectTex, screen);
				col.rgb = pow(col.rgb, 2)*1.1;//gamma (check if needed)
				col *= alpha;
				

				// blend with model
				fixed4 modelTex = tex2D(_ModelTex, i.uv);
				fixed4 maskTex = tex2D(_MaskTex, i.uv);
				float blend = clamp(maskTex.r*_Mask1 + maskTex.g*_Mask2 + maskTex.b*_Mask3,0,1);

				return modelTex*(1 - col.a*blend) + col*blend;
			}
			ENDCG
		}
	}
}
