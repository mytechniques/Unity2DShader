Shader "Custom/Highlight" {
	Properties {
		[HideInInspector]
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_HighlightColor("HighLight Color",Color) = (0,0,0,0)
		_Center("Center",Vector) = (0.5,0.5,0,0)
		_Size("Size",Range(0,1)) = 0
		_Radius("Radius",Range(0,1)) = 0
			

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
		sampler2D _MainTex_ST;
		fixed4 _Color;
		fixed4 _HighlightColor;
		fixed _Highlight;
		fixed _Radius;
		fixed _Size;
		fixed2 _Center;
		fixed _Opaque;
		struct appdata_t{
			half4 vertex: POSITION;
			half2 texcoord : TEXCOORD0;
			half4 color : COLOR;
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
			fixed4 o =  tex2D(_MainTex,IN.texcoord);
			bool radius = (pow(IN.texcoord.x - _Center.x,2) + pow(IN.texcoord.y - _Center.y,2)) > pow(_Radius,2)/2;
			if(radius && _Opaque)
				return (1,1,1,1);
			
			if(o.a >0 && o.a < _Size && radius   && _Highlight)
			{
					return _HighlightColor;
			}
			return o;
		}


		ENDCG
	}
		}
	FallBack "Sprites/Default"
}
