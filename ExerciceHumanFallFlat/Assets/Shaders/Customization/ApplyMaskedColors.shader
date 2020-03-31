// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CharacterCustomize/ApplyMaskedColors"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_Color("Color1", Color) = (1,0,0,1)
		_Color("Color2", Color) = (0,1,0,1)
		_Color("Color3", Color) = (0,0,1,1)
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma target 3.0
			// make fog work
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD2;  
				
			};

			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _Color1;
			float4 _Color2;
			float4 _Color3;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;// TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//float2 screen = i.screen.xy/i.screen.w/2+0.5;

				//float2 screenPos = ((IN.Pos.xy / IN.Pos.w) + 1) / 2
				// sample textures
				fixed4 base = tex2D(_MainTex, i.uv);
				fixed4 mask = tex2D(_MaskTex, i.uv);


				float3 m = mask.rgb;

				//mix clamping 1: if sum over 1 scale proportionally (EQUALITY)
				float s = m.r + m.g + m.b;
				m = m / (s+0.0001);// lerp(m, m / s, step(1, s));

				//mix clamping 2: layering b then g then r (PRIORITY)
				//m.g = clamp(m.g, 0, 1 - m.r);
				//m.b = clamp(m.b, 0, 1 - m.r-m.g);

				// BAD: mix clamping 3: layering using lerp (creates holes in gradients)
				//m.g = lerp(m.g, 0, m.r);
				//m.b = lerp(m.b, 0, m.r+m.g);

				float4 c1 = _Color1 *m.r;
				float4 c2 = _Color2 *m.g;
				float4 c3 = _Color3 *m.b;
				float4 mixed = c1 + c2 +c3;

				mixed.rgb /= (mixed.a+0.0001);

				
				
				return lerp(base, mixed, min(mask.a,mixed.a));
				//return lerp(base, mixed, mask.a  *mixed.a+ clamp(mask.r+mask.g+mask.b, 0, 1));
				//fixed4 image = (sin((i.uv.x+i.uv.y)*200+_Time.y*5)+1)/2;
				//return lerp(base,image,mask);
			}
			ENDCG
		}
	}
}
