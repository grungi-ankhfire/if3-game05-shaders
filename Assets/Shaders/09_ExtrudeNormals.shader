Shader "Interface3/09-Extrude Normals"
{
    Properties
    {
		_MainTex("Main Texture", 2D) = "white" {}
		_Amount("Extrusion Amount", Range(-0.1, 0.1)) = 0
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _Amount;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v) {
			v.vertex.xyz += _Amount * v.normal;
		}

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG

    }
    FallBack "Diffuse"
}
