Shader "Interface3/07-ScrollingUVs"
{
    Properties
    {
		_MainTex("Main Texture", 2D) = "white" {}
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

		struct Input {
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex + _SinTime.z).rgb;
		}

		ENDCG

    }
    FallBack "Diffuse"
}
