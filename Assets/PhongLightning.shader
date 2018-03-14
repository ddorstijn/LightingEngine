// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/PhongLightning"
{
	Properties
	{
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Float) = 10
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform float4 _LightColor0;

            uniform float4 _DiffuseColor;
            uniform float4 _SpecColor;
            uniform float _Shininess;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float3 worldNormal : NORMAL;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            fixed4 frag(v2f i) : COLOR
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w;
                float3 normalDir = normalize(i.worldNormal);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                // Blinn-phong
    			half3 halfDir = normalize(lightDir + viewDir);
				float specAngle = max(dot(halfDir, normalDir), 0.0);
				float specularAmount = pow(specAngle, 1.0/_Shininess);
				float3 specularLight = _SpecColor.rgb * _LightColor0.rgb * specularAmount;

				float NdotL  = max(0.0, dot(i.worldNormal, lightDir));
				float3 diffuse = _DiffuseColor * _LightColor0.rgb * NdotL;

				return float4(diffuse + specularLight, 1.0);
            }

            ENDCG
		}
	}
}
