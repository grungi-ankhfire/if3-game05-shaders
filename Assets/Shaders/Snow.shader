Shader "Interface3/Snow"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_Bump("Normal map", 2D) = "bump" {}
		_Snow("Level of snow", Range(-1, 1)) = 0
		_SnowColor("Snow color", Color) = (1, 1, 1, 1)
		_SnowDirection("Snow direction", Vector) = (0, 1, 0)
		_SnowDepth("Snow depth", Float) = 0.01
	}

	SubShader
	{
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		CGPROGRAM

		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex, _Bump;
		float _Snow, _SnowDepth;
		half4 _SnowColor;
		half3 _SnowDirection;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			INTERNAL_DATA
		};

		void vert(inout appdata_full v)
		{
			// Convert _SnowDirection from world space to object space
			float4 sn = mul(_SnowDirection, unity_WorldToObject);
			if (saturate(dot(v.normal, sn.xyz)) >= _Snow) {
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth;
			}
		}

		void surf(Input IN, inout SurfaceOutput o) {
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_MainTex));
			if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow) {
				o.Albedo = _SnowColor;
			}
			else {
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			}
		}

		ENDCG
    }
}
