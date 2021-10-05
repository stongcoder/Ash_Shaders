// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/Scanner"
{
    Properties
    {    
        _MainTex("MainTex",2D)="white"{}
        _ScanDis("ScanDis",float)=0
        _ScanWidth("ScanWidth",float)=10
        _ScanColor("ScanColor",Color)=(1,1,1,0)
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
            float _ScanWidth;
			float4 _ScanColor;
            float _ScanDis;
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
                if(linear01Depth<_ScanDis &&linear01Depth>_ScanDis-_ScanWidth&&linear01Depth<1) //1对应的是远裁切面，因此如果不判断1的话，整个远方最后都会被扫描网的颜色进行叠加。
                {
                    return fixed4(1,0,0,1);
                }
                fixed4 col=tex2D(_MainTex,i.uv);
                return col ;
            }
            ENDCG
        }
    }
}