Shader "Custom/Highlight" {
	Properties {
		[HideInInspector]
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_HighlightColor("HighLight Color",Color) = (0,0,0,0)
		_OpaqueColor("Opaque Color",Color) = (0,0,0,0)
//		_Center("Center",Vector) = (0.5,0.5,0,0)
		_Opacity("Opacity",Range(0,1)) = 0
//		_Radius("Radius",Range(0,1)) = 0
			

		[MaterialToggle]
		_Highlight("Highlight",Range(0,1)) = 1

		[MaterialToggle]
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
		fixed _Opacity;
		fixed _Opaque;
		struct appdata{
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;
			half4 color : COLOR;
		};
		struct v2f {
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;
			fixed4 color : COLOR;

		};
		v2f vert(appdata IN){
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord;
			OUT.color = IN.color;
			return OUT;
		}

		fixed4 frag(v2f IN):COLOR{
			fixed4 o =  tex2D(_MainTex,IN.texcoord);
//			bool radius = (pow(IN.texcoord.x - _Center.x,2) + pow(IN.texcoord.y - _Center.y,2)) > pow(_Radius,2)/2;
			
//			 (1,1,1,1);
			if(_Highlight){
				if(o.a >0 && o.a < _Opacity  )
				{
					return _HighlightColor;
				}

			if(_Opaque && o.a > 0)
				return _OpaqueColor;
			}
			return o * IN.color;
		}


		ENDCG
	}
		}
	FallBack "Sprites/Default"
}
