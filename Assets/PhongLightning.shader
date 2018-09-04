// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

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
                // Spotlights
                float3 vert2LightSource = _WorldSpaceLightPos0.xyz - i.worldPos.xyz;
                float oneOverDistance = 1.0 / length(vert2LightSource);
                float attenuation = lerp(1.0, oneOverDistance, _WorldSpaceLightPos0.w);

                float3 lightDir = _WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w;
                float3 normalDir = normalize(i.worldNormal);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                // Blinn-phong
                half3 halfDir = normalize(lightDir + viewDir);
                float specAngle = max(dot(halfDir, normalDir), 0.0);
                float specularAmount = pow(specAngle, 1.0/_Shininess);
                float3 specularLight = _SpecColor.rgb * _LightColor0.rgb * specularAmount;

                float NdotL = max(0.0, dot(i.worldNormal, lightDir));

                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb* _DiffuseColor;
                float3 diffuse = _DiffuseColor * _LightColor0.rgb * NdotL;

                return float4(diffuse + ambient + specularLight, 1.0);
            }

            ENDCG
        }
        Pass
        {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One

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
                // Spotlights
                float3 vert2LightSource = _WorldSpaceLightPos0.xyz - i.worldPos.xyz;
                float oneOverDistance = 1.0 / length(vert2LightSource);
                float attenuation = lerp(1.0, oneOverDistance, _WorldSpaceLightPos0.w);

                float3 lightDir = _WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w;
                float3 normalDir = normalize(i.worldNormal);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                // Blinn-phong
                half3 halfDir = normalize(lightDir + viewDir);
                float specAngle = max(dot(halfDir, normalDir), 0.0);
                float specularAmount = pow(specAngle, 1.0/_Shininess);
                float3 specularLight = _SpecColor.rgb * _LightColor0.rgb * specularAmount;

                float NdotL  = max(0.0, dot(i.worldNormal, lightDir));

                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb* _DiffuseColor;
                float3 diffuse = _DiffuseColor * _LightColor0.rgb * NdotL;

                return float4(attenuation * diffuse + specularLight, 1.0);

                // float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); //Diffuse component
                // float3 specularReflection;
                // if (dot(i.normal, lightDirection) < 0.0) //Light on the wrong side - no specular
                // {
                //     specularReflection = float3(0.0, 0.0, 0.0);
                // }
                // else
                // {
                //     //Specular component
                //     specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                // }

                // float3 color = (diffuseReflection) * tex2D(_Tex, i.uv) + specularReflection; //No ambient component this time
                // return float4(color, 1.0);
            }

            ENDCG
        }
	}
}
