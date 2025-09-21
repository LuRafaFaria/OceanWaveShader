Shader "Custom/WaveStandard"
{

    Properties
    { 

		//NOTA: Os valores iniciados são os recomendados
        _OceanTexture("OceanTexture", 2D) = "white" {} //Textura: oceano
        _Noise("Noise", 2D) = "white" {} //Textura: noise

			
        [Toggle] _Ondas("Ondas", Float) = 0 //Toggle para verificar se é para substituir o mar por uma textura de oceano
        [Toggle] _Movimento("Movimento", Float) = 0 //Toggle para verificar se é para utilizar o movimento das ondas
			
        _BlendingWave("WaveBlending", Range(0, 1)) = 0.5 //Valor de blending na funcção do lerp
        _WaveSpeed("WaveSpeed", Range(0, 0.5)) = 0.03 //Velocidade das ondas
        _DoWiggle("DoWiggle", Range(0, 5)) = 0.5 //Aumentar ou diminuir o wiggle
    }

    SubShader
    {
		//Face exterior da esfera
	    Cull back
        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 4.6
        
        sampler2D _OceanTexture;
        sampler2D _Noise;
        float _Ondas;
        float _Movimento;
        float _WaveSpeed;
		float _DoWiggle;
		float _BlendingWave;


        struct Input
        {
            float2 uv_OceanTexture;
            float2 uv_Noise;
        };

        struct appdata
        {
			float3 normal : NORMAL;
			float4 vertex : POSITION;
            float4 texcoord : TEXCOORD0;
            float2 uv : TEXCOORD1;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float2 waveUvs = 0.1 * float2(sin(_Time.y * _WaveSpeed + IN.uv_Noise.y * _DoWiggle), cos(_Time.y * _WaveSpeed + IN.uv_Noise.x * _DoWiggle));		
			o.Albedo = lerp(tex2D(_OceanTexture, IN.uv_Noise + float2(waveUvs.x, waveUvs.y)), tex2D(_OceanTexture, IN.uv_Noise + float2(waveUvs.y, -waveUvs.x)), _BlendingWave);
        }
        ENDCG
    }

    FallBack "Diffuse"
}
