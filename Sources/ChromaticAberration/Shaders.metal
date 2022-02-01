
#include <metal_stdlib>
using namespace metal;

kernel void kernel_chromatic_aberration(texture2d<float, access::read> texture [[texture(0)]],
                                    texture2d<float, access::write> outTexture [[texture(1)]],
                                    constant uint &rOffset [[buffer(0)]],
                                    constant uint &gOffset [[buffer(1)]],
                                    constant uint &bOffset [[buffer(2)]],
                                    uint2 gid [[thread_position_in_grid]]
                                    ) {
  
  const float4 r = texture.read(uint2(gid.x, gid.y + rOffset));
  const float4 g = texture.read(uint2(gid.x, gid.y + gOffset));
  const float4 b = texture.read(uint2(gid.x, gid.y + bOffset));
  
  const float4 outColor = float4(r.r, g.g, b.b, 1.0);
  
  outTexture.write(outColor, gid);
}
