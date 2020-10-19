Shader "Interface3/06-Masked Textures"
{
    Properties
    {
		_MainTex("Main Texture", 2D) = "white" {}
		_SecondTex("Second Texture", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_Color("Color", Color) = (1, 0, 0, 1)
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _SecondTex;
		sampler2D _Mask;
		half4 _Color;		

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecondTex;
			float2 uv_Mask;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			float PI = 3.1415926;
			//float m = 1 - tex2D(_Mask, IN.uv_Mask).r;
			float m = 0.5 * (1 + sin(IN.uv_MainTex.y * 2 * PI * 3 + _Time.w));

			// m * col1 + (1-m) * col2
			o.Albedo = m * tex2D(_MainTex, IN.uv_MainTex).rgb + (1-m) * tex2D(_SecondTex, IN.uv_SecondTex).rgb;
			o.Albedo *= _Color.rgb;
		}

		ENDCG

    }
    FallBack "Diffuse"
}
