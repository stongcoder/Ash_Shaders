// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/DepthRender"
{
    Properties
    {    
        _MainTex("MainTex",2D)="white"{}

    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque" 
        }

        Pass
        {           
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;              
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _CameraDepthTexture;

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv=v.uv;
                return o;
            }
            
            fixed4 frag (v2f i) : COLOR
            {
                //计算当前像素深度
                i.uv=TRANSFORM_TEX(i.uv,_MainTex);
                float  depth=UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
                float linear01Depth =Linear01Depth(depth);              
                return linear01Depth;
            }
            ENDCG
        }
    }
}