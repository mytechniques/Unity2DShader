Shader "Custom/Flash" {
	Properties {
		[HideInInspector]
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_FlashColor("Flash Color",Color) = (0,0,0,0)

		_Flash("Flash",Range(0,1)) = 0

	}
	SubShader {
	   LOD 200

    Tags
    {
        "Queue" = "Transparent"
        "IgnoreProjector" = "True"
        "RenderType" = "Transparent"
    }

    Pass
    {
        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        ColorMask RGB
        Blend SrcAlpha OneMinusSrcAlpha

		
		CGPROGRAM
		#define TRUE 1
		#define FALSE 0
		#include "UnityCG.cginc"
		#pragma vertex vert
		#pragma fragment frag

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		sampler2D _MainTex;
		fixed4 _FlashColor;
		fixed _Flash;

		struct appdata_t{
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;
		};
		struct v2f {
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;

		};
		v2f vert(appdata_t IN){
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord;
			return OUT;
		}
		fixed4 frag(v2f IN)	:COLOR	{
			fixed4 o =  tex2D(_MainTex,IN.texcoord);
				if(o.a == 0)
					return (0,0,0,0);
		
				return lerp(_FlashColor,o,_Flash);
			
		}


		ENDCG
	}
	}
	FallBack "Sprites/Default"
}
