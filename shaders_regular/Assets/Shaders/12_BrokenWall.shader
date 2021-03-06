﻿Shader "Interface3/12_Broken Wall"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_SecondaryTex("Secondary (RGB)", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
		_Cutoff("Cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _SecondaryTex;
		sampler2D _MaskTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_SecondaryTex;
			float2 uv_MaskTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
		half _Cutoff;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		float compute_mask(float2 uv) {
			float res = tex2D(_MaskTex, uv);
			//res = step(_Cutoff, res);
			return res;			
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float m = compute_mask(IN.uv_MaskTex);
			float m_right = compute_mask(IN.uv_MaskTex + half2(0.001, 0));
			float m_up = compute_mask(IN.uv_MaskTex + half2(0, 0.001));
            
			half3 vec1 = normalize(half3(0.1, 0, m_right - m));
			half3 vec2 = normalize(half3(0, 0.1, m_up - m));
			o.Normal = cross(vec1, vec2);			

			// Albedo comes from a texture tinted by color
            fixed4 c = m * tex2D (_MainTex, IN.uv_MainTex) + (1-m) * tex2D (_SecondaryTex, IN.uv_SecondaryTex);
			c *= _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
			//o.Normal...
        }
        ENDCG
    }
    FallBack "Diffuse"
}
