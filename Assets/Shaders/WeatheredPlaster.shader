// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Interface3/WeatheredPlaster"
{

	Properties{
		_MainTex("Main Texture", 2D) = "white" {}
		_SecondaryTex("Secondary", 2D) = "white" {}
		_NoiseTex("Noise", 2D) = "white" {}

		_NormalHardness("Normal Hardness", Range(1, 1000)) = 300
		_NormalSamplingSize("Normal Sampling Size", Range(0.001, 1)) = 0.01

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}

		SubShader
		{
			Tags {
				"RenderType" = "Opaque"
			}
			LOD 200

			CGPROGRAM

			#include "UnityStandardUtils.cginc"
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard vertex:vert fullforwardshadows addshadow
			
			// Use shader model 3.0 or 4.0 target, to get nicer looking lighting
			#pragma target 4.0

			struct Input
			{
				float3 worldPos;
				float3 worldNormal;
				float4 color : COLOR;
				half3 tangent_input;
				half3 binormal_input;
				float3 localPos;
				float3 localNormal;
				float2 uv_MainTex;
				float2 uv_SecondaryTex;
				float2 uv_NoiseTex;
				INTERNAL_DATA
			};

			sampler2D _MainTex, _SecondaryTex, _NoiseTex;
			half _NormalHardness, _NormalSamplingSize;
			half _Glossiness;
			half _Metallic;

			void vert(inout appdata_full v, out Input data) {
				UNITY_INITIALIZE_OUTPUT(Input, data);

				data.localPos = v.vertex;
				data.localNormal = v.normal;

				half3 p_normal = mul(v.normal.xyz, (float3x3)unity_WorldToObject);
				half3 p_tangent = mul(v.tangent.xyz, (float3x3)unity_WorldToObject);

				half3 normal_input = normalize(p_normal.xyz);
				half3 tangent_input = normalize(p_tangent.xyz);
				half3 binormal_input = cross(p_normal.xyz,tangent_input.xyz) * v.tangent.w;

				data.tangent_input = v.tangent.xyz;
				data.binormal_input = cross(v.normal.xyz, tangent_input.xyz) * v.tangent.w; ;


			}

			float3 compute_noise(float2 uv, float threshold, bool saturate_noise) {
				//const float minThreshold = 0.05;
				//const float maxThreshold = 0.50;

				//float thresh = minThreshold + (maxThreshold - minThreshold) * threshold;

				float3 noise_result = tex2D(_NoiseTex, uv);
				
				if (noise_result > threshold) {
					//noise_result = saturate((noise_result - thresh) * _NormalHardness);
					//noise_result = pow(noise_result, 3);
				}
				return noise_result;
			}

				void surf(Input IN, inout SurfaceOutputStandard o)
				{

					float3 lowFreqNoise = compute_noise(IN.uv_NoiseTex, 0.5, false);

					IN.worldNormal = WorldNormalVector(IN, float3(0,0,1));

					fixed4 col = tex2D(_MainTex, IN.uv_MainTex);
					fixed4 col2 = tex2D(_SecondaryTex, IN.uv_SecondaryTex);

					float3 noise = compute_noise(IN.uv_NoiseTex, lowFreqNoise.r, true);

					o.Albedo = noise * col + (1 - noise) * col2;
					o.Metallic = _Metallic;
					o.Smoothness = _Glossiness;

					const float2 size = float2(2.0,0.0);
					const int3 off = int3(-1,0,1);
					float s11 = noise.x;

					float s21 = compute_noise(IN.uv_NoiseTex + half2(1, 0) * _NormalSamplingSize, lowFreqNoise.x, true).x;
					float s12 = compute_noise(IN.uv_NoiseTex + half2(0, 1) * _NormalSamplingSize, lowFreqNoise.x, true).x;
					float3 va = normalize(float3(size.xy, s21 - s11));
					float3 vb = normalize(float3(size.yx, s12 - s11));
					o.Normal = cross(va,vb);

				}
				ENDCG
		}
		FallBack "Diffuse"
}
