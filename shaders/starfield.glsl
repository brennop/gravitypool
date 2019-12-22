number Noise2d( in vec2 x ){
    number xhash = cos( x.x * 10.0 );
    number yhash = cos( x.y * 20.0 );
    return fract( 415.92653 * ( xhash + yhash ) );
}

number Starfield(in vec2 coord, number threshold ) {
  number star = Noise2d ( coord );
  if(star >= threshold ) 
    star = pow((star - threshold)/(1.0 - threshold), 6.0);
  else
    star = 0.0;
  return star;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
  vec3 vColor = vec3(0.02, 0.0, 0.03);
  vColor += vec3(0.05, 0.01, 0.1) * texture_coords.y;
  number star = Starfield(texture_coords, 0.99);
  vColor += vec3(star);
  return vec4(vColor, 1.0);
}
