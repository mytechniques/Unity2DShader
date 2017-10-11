// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sprites/ClipArea"
{
Properties
{
	[HideInInspector]
    _MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}

    _Vertical ("Vertical", Range(0.0, 1.0)) = 1.0
    _InverseVertical ("Inverse Vertical", Range(0.0, 1.0)) = 1.0

    _Horizontal ("Horizontal", Range(0.0, 1.0)) = 1.0
    _InverseHorizontal ("Inverse Horizontal", Range(0.0, 1.0)) = 1.0

    _Squad ("Squad", Range(0.0, 1.0)) = 1.0
	_SquadAngle ("Squad Angle", Range(0.0, 1.0)) = 1.0
	_InverseSquadAngle ("Inverse Squad Angle", Range(0.0, 1.0)) = 1.0

    _Circle ("Circle", Range(0.0, 1.0)) = 1.0
    _CircleAngle ("Circle Angle",Range(0.0,1.0)) = 1.0
    _InverseCircleAngle("Inverse Circle Angle",Range(0.0,1.0)) = 1.0


    _Color ("Base color",COLOR) = (1,1,1,1)
    _FillColor ("Fill color",COLOR) = (0,0,0,0)
      	



  	[MaterialToggle]
    _IgnoreTexture("Opaque",Range(0,1)) = 0

    [MaterialToggle]
    _Transparent("Transparent",Range(0,1)) = 0

    [MaterialToggle]
    _ClearAlpha("Clear Alpha",Range(0,1)) = 0

//   [HideInInspector]

 }

SubShader
{
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
        Offset -1, -1
        Fog { Mode Off }
        ColorMask RGB
        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM
        #define TRUE 1
        #define FALSE 0
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed _Vertical;
        fixed _Horizontal;
        fixed _InverseHorizontal;
        fixed _InverseVertical;
        fixed _ClearAlpha;
        fixed _Transparent;
        fixed _Squad;
        fixed _Circle;
        fixed _SquadAngle;
        fixed _CircleAngle;
        fixed _InverseSquadAngle;
        fixed _InverseCircleAngle;
        fixed _IgnoreTexture;

        fixed4 _Color;
        fixed4 _FillColor;

        struct appdata_t
        {
            half4 vertex : POSITION;
            half2 texcoord : TEXCOORD0;
            fixed4 color :COLOR;
        };

        struct v2f
        {
            half4 vertex : POSITION;
            half2 texcoord : TEXCOORD0;
            fixed4 color : COLOR;
        };

        v2f vert (appdata_t v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);	
            o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
            o.color = v.color;
            return o;
        }

        half4 frag (v2f IN) : COLOR
        {
        	half4 result =  tex2D(_MainTex, IN.texcoord);
        	bool h = IN.texcoord.x > _Horizontal ;
        	bool ih = IN.texcoord.x < 1 - _InverseHorizontal;

        	bool v = IN.texcoord.y > _Vertical  ;
        	bool iv = IN.texcoord.y < 1 - _InverseVertical;

        	bool z = (IN.texcoord.x <= 0) || (IN.texcoord.y <= 0);
        	bool s = (IN.texcoord.x - 0.5 > _Squad/2 || IN.texcoord.y - 0.5 > _Squad/2) || (IN.texcoord.x * 2  < (1 - _Squad) ||IN.texcoord.y * 2  < (1 - _Squad));
        	bool sa = (IN.texcoord.x + IN.texcoord.y)/2  > _SquadAngle;
        	bool isa = (IN.texcoord.x + IN.texcoord.y)/ 2 < 1 - _InverseSquadAngle;


        	bool c = (pow(IN.texcoord.x - .5,2) + pow(IN.texcoord.y - 0.5,2))  > pow(_Circle,2)/2;
        	bool ca = (pow(IN.texcoord.x,2) + pow(IN.texcoord.y ,2))/2  > pow(_CircleAngle,2);
        	bool ica = ((pow(IN.texcoord.x,2) + pow(IN.texcoord.y ,2))/2 < 1-  (_InverseCircleAngle));
        	if(_ClearAlpha == TRUE && result.a == 0){
        		return (0,0,0,0);
        	}

            if (h  || ih || v  || iv || s || sa || isa ||  c || ca || ica) {
          	  return (_Transparent == TRUE ? result * _FillColor : 	_FillColor);
            }
            	
            	     return _IgnoreTexture == TRUE ? _Color : result * _Color;

        }
        ENDCG
    }
}
}