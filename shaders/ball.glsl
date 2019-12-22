extern vec2 pos; 

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
  vec3 l = vec3(0.5 - pos.x, -0.4, 0.7);
  vec2 uv = (texture_coords - 0.5) * 2.0;
  float radius = length(uv);
  vec3 normal = vec3(uv.x, uv.y, sqrt(1.0 - uv.x*uv.x - uv.y*uv.y));
  float ndotl = max(0.0, dot(normal, l));
  // ndotl = ndotl > 0.3 ? 1 : 0.2;
  ndotl = min(1.0, 1.4 - 1.0 / (1.0 + exp(20 * (ndotl - 0.2))));
  vec4 fColor = color * vec4(ndotl, ndotl, ndotl, 1.0);
  float delta = fwidth(radius);
  float alpha = 1.0 - smoothstep(1.0 - delta, 1.0 + delta, radius);
  return  fColor * alpha;
}

