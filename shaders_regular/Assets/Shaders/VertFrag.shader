// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Interface3/VertFrag"
{
	Properties
	{
		_Color("Color", Color) = (1, 0, 0, 1)
	}
		SubShader
	{
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			half4 _Color;

			struct vertInput {
				float4 pos : POSITION;
			};

			struct vertOutput {
				float4 pos : SV_POSITION;
			};

			vertOutput vert(vertInput input) {
				vertOutput o;
				o.pos = UnityObjectToClipPos(input.pos);
				//o.pos = unity_ObjectToClipPos(input.pos);
				return o;
			}

			half4 frag(vertOutput output) : COLOR{
				return _Color;
			}

            ENDCG
        }
    }
}
