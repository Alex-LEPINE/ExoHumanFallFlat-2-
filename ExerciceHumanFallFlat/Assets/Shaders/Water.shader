Shader "Custom/Water" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Scale ("Scale",Range(0,2)) = 1.0
		_Time2("Time",Range(0,1000000)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Cull Off
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows addshadow  vertex:vert


		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 color : COLOR;
		};

		half _Glossiness;
		half _Metallic;
		half _Scale;
		half _Time2;
		fixed4 _Color;

		struct appdata_full_uv3
		{
			float4 vertex    : POSITION;  // The vertex position in model space.
			float3 normal    : NORMAL;    // The vertex normal in model space.
			float3 texcoord  : TEXCOORD0; // The first UV coordinate.
			float4 texcoord1 : TEXCOORD1; // The second UV coordinate.
			float3 texcoord2 : TEXCOORD2; // The second UV coordinate.
			float3 texcoord3 : TEXCOORD3; // The second UV coordinate.
			float4 tangent   : TANGENT;   // The tangent vector in Model Space (used for normal mapping).
			//float4 color     : COLOR;     // Per-vertex color
		};

		float3 transform(float3 pos)
		{
			//pos.z += 
			//	_Scale*(.2*sin(20 * _Time.x + .5*pos.x + .2*pos.y) // shape
			//	+ .13*sin(50 * _Time.x + 21113 * pos.x + 12115 * pos.y)); // noise
			pos.z +=
				_Scale*(.2*sin(_Time2 + .5*pos.x + .2*pos.y) // shape
					+ .13*sin(2.5* _Time2 + 21113 * pos.x + 12115 * pos.y)); // noise

			return pos;
		}
		void vert(inout appdata_full_uv3 v) {
			float3 v0 = transform(v.vertex);
			float3 v1 = transform(v.texcoord);
			float3 v2 = transform(v.texcoord3);
			v.vertex = float4(v0,1);
			v.normal = normalize(cross(v1 - v0, v2 - v0));
			//v.color = float4(0, 1, 1, 1); //v1.xyzz;// v.texcoord3.xyzz;// float4(v1, 1);
			//v.normal = normalize(cross(v1 - v0, v2 - v0));
		}


		void surf (Input IN, inout SurfaceOutputStandard o) {
			//o.Albedo = IN.color;
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
