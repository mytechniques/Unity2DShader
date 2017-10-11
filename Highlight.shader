Shader "Custom/Highlight" {
	Properties {
		[HideInInspector]
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_HighlightColor("HighLight Color",Color) = (0,0,0,0)
		_OpaqueColor("Opaque Color",Color) = (0,0,0,0)
		_Highlight("Highlight ",Range(0,1)) = 1

		_Opaque("Opaque",Range(0,1)) = 1

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
		#include "UnityCG.cginc"
		#pragma vertex vert
		#pragma fragment frag

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		sampler2D _MainTex;
		fixed4 _HighlightColor, _OpaqueColor;

		fixed _Highlight;
		fixed _Opaque;
		struct appdata_t{
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;
			fixed4 color : COLOR;
		};
		struct v2f {
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;
			fixed4 color : COLOR;

		};
		v2f vert(appdata_t IN){
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord;
			OUT.color = IN.color;
			return OUT;
		}

		fixed4 frag(v2f IN):COLOR{
			fixed4 o =  tex2D(_MainTex,IN.texcoord) * IN.color;
			bool alpha = o.a > 0 && o.a < _Highlight;
				if(alpha)
					return _HighlightColor;

				if(o.a > 0)
				return lerp(o,_OpaqueColor,_Opaque);

			return o;
		}


		ENDCG
	}
		}
	FallBack "Sprites/Default"
}
