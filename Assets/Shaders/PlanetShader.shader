Shader "Unlit/PlanetShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        _Height("Height", Range(-1,1)) = 0
        _Seed("Seed", Range(0,10000)) = 10
        
        _Color1("Water color", Color) = (1,1,1,1)
        _Color2("Grass color", Color) = (1,1,1,1)
        _Color3("Rocks color", Color) = (1,1,1,1)
        
        _Step1("Threshold 1", Range(0,1)) = 0.4
        _Step2("Threshold 2", Range(0,1)) = 0.7
        
        _Color ("Atmosphere Color", Color) = (1, 1, 1, 0.1)
        _Offset ("Atmosphere Offset", Range(0,20)) = 0.5
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Height;
            float _Seed;

            float hash(float2 st) {
                return frac(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);
            }

            float noise(float2 p, float size)
            {
                p *= size;
                float2 i = floor(p + _Seed);
                float2 f = frac(p + _Seed / 739);
                float2 e = float2(0, 1);
                float z0 = hash((i + e.xx) % size);
                float z1 = hash((i + e.yx) % size);
                float z2 = hash((i + e.xy) % size);
                float z3 = hash((i + e.yy) % size);
                float2 u = smoothstep(0, 1, f);
                float result = lerp(z0, z1, u.x) + (z2 - z0) * u.y * (1.0 - u.x) + (z3 - z1) *
                    u.x * u.y;
                return result;
            }

            v2f vert (appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float height = noise(v.texcoord, 5) * 0.75 + noise(v.texcoord, 30) *
                    0.125 + noise(v.texcoord, 50) * 0.125;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.r = height + _Height;
                return o;
            }

            

            float4 _Color1;
            float4 _Color2;
            float4 _Color3;

            float _Step1;
            float _Step2;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float height = i.uv.r;
                if (height < _Step1)
                {
                    col.xyz = _Color1;
                }
                else if (height < _Step2)
                {
                    col.xyz = _Color2;
                }
                else
                {
                    col.xyz = _Color3;
                }
                return col;
            }
            ENDCG
        }
        Pass
        {
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Offset;
            float4 _Color;

            v2f vert (appdata_full v)
            {
                v2f o;
                v.vertex.xyz *= 1 + _Offset;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
