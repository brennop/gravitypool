extern vec2 pos;
extern vec2 ratio;

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  vec2 offset = texture_coords - pos;
  float rad = length(offset/ratio);
  float deformation = 1/pow(rad*pow(30, 0.5), 2) * 0.005 * 2;
  offset *= (1-deformation);
  offset += pos;
  return Texel(tex, offset);
}
