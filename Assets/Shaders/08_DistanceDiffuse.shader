Shader "Interface3/08-Distance Diffuse"
{
    Properties
    {
		_MainTex("Main Texture", 2D) = "white" {}
		_Center("Center", Vector) = (0, 0, 0, 0)
		_Radius("Radius", Float) = 0.5
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
		float3 _Center;
		float _Radius;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			float d = distance(IN.worldPos, _Center);
												  
			float m = step(_Radius - 0.1, d) * step(d, _Radius + 0.1);
			
			o.Albedo = (1-m) * tex2D(_MainTex, IN.uv_MainTex + _SinTime.z).rgb + m * half4(0, 1.0, 0, 1);
		}

		ENDCG

    }
    FallBack "Diffuse"
}
