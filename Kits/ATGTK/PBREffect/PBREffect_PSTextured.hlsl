//--------------------------------------------------------------------------------------
// PBREffect_PSTextured.hslsi
//
// A physically based shader for forward rendering on DirectX 12.
//
// Advanced Technology Group (ATG)
// Copyright (C) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

#include "PBREffect_Common.hlsli"

// Pixel shader: pixel lighting + texture.
[RootSignature(PBREffectRS)]
float4 PSTextured(PSInputPixelLightingTxTangent pin) : SV_Target0
{
    // vectors
    const float3 V = normalize(PBR_EyePosition - pin.PositionWS.xyz); // view vector
    const float3 L = normalize(-PBR_LightDirection[0]);               // light vector ("to light" oppositve of light's direction)
     
    // Before lighting, peturb the surface's normal by the one given in normal map.
    float3 localNormal = (PBR_NormalTexture.Sample(PBR_SurfaceSampler, pin.TexCoord).xyz * 2) - 1;
    
    float3 N = PeturbNormal( localNormal, pin.NormalWS, pin.TangentWS);

    // Get albedo, then roughness, metallic and ambient occlusion
    float3 albedo = PBR_AlbedoTexture.Sample(PBR_SurfaceSampler, pin.TexCoord).rgb;
    float3 RMA = PBR_RMATexture.Sample(PBR_SurfaceSampler, pin.TexCoord);
  
    // Shade surface
    float3 output = PBR_LightSurface(V, N, 3, PBR_LightColor, PBR_LightDirection, albedo, RMA.x, RMA.y, RMA.z);

    return float4(output, 1);
}
