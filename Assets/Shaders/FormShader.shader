Shader "Unlit/FormShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Height("Height", Range(0,20)) = 0.5
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

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Height;

            v2f vert (appdata_full v)
            {
                v2f o;
                v.vertex.xy -= v.normal * _Height * v.texcoord.x * v.texcoord.x;
                v.vertex.xy -= v.normal * _Height * -v.texcoord.x;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
