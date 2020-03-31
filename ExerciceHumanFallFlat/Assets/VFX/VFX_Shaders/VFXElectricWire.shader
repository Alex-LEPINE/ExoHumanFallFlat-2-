Shader "VFX/ElectricWires"
{
Properties
{
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    [HDR] _Colour ("Colour", Color) = (1,1,1,1)    
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    _USpeed ("U Speed", Float) = 0
    _VSpeed ("V Speed", Float) = 2
    _Frames("Num U Frames", Int) = 3
}

SubShader
{
    Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
    LOD 100

    Lighting Off

    Pass
    {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Colour;
            fixed _Cutoff;
            fixed _USpeed;
            fixed _VSpeed;
            fixed _Frames;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                fixed2 u = fixed2(
                    floor(frac(_Time.y * _USpeed) * _Frames) / _Frames,
                    frac(_Time.y * _VSpeed)
                    );

                o.texcoord += u;

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);
                clip(col.a - _Cutoff);
                UNITY_APPLY_FOG(i.fogCoord, col);

                return col * _Colour;
            }
        ENDCG
    }
}

}
