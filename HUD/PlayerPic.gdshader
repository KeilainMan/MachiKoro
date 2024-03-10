shader_type canvas_item;

uniform bool turn_bool;
uniform sampler2D noise_pattern: repeat_enable;
uniform sampler2D alpha_noise_pattern: repeat_enable;
uniform sampler2D flame_gradient;
uniform vec2 scroll = vec2(0.5, 0.5);
uniform sampler2D alpha_gradient;
uniform float blur: hint_range(0, 7) = 3.0;
uniform float intensity_factor: hint_range(0.0, 5.0) = 1.5;


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	
    float cosa = cos(rotation);	// Get the cos angle for the rotation
    float sina = sin(rotation);	// Get the sin angle for the rotation
	// Offset the pivot point
    uv -= pivot;
	// Calculate the rotation with basic trigonometry
	// https://education.siggraph.org/static/HyperGraph/modeling/mod_tran/2drota.htm
	// "+ pivot" restores the offset to default
    return vec2(cosa * uv.x - sina * uv.y, 
				cosa * uv.y + sina * uv.x) + pivot;
}


void fragment() {
	if (turn_bool){
	vec2 myUv = rotateUV(UV,vec2(0.5,0.5), radians(90));
	float tex_alpha = texture(TEXTURE, UV).a;
	float pattern_intensity = texture(noise_pattern, UV + TIME * scroll).r;
	float alpha = texture(alpha_gradient, myUv).a; //* texture(alpha_noise_pattern, UV + TIME * vec2(0.0,0.2)).r;
	float intensity = pattern_intensity * intensity_factor * alpha;
	vec4 flame_color = texture(flame_gradient, vec2(intensity));
	COLOR = vec4(flame_color.rgb - vec3(0,0,0), tex_alpha * alpha);
	}

	//COLOR = texture(flame_gradient, vec2(intensity));
}
	
//	float tex_alpha = texture(TEXTURE, UV).a;
//	float pattern_intensity = texture(noise_pattern, UV + TIME * scroll).r;
//	float intensity = pattern_intensity * intensity_factor;// * texture(flame_gradient).r;
//	vec3 temp_col = intensity * texture(flame_gradient, UV).rgb;
//	float alpha = texture(alpha_gradient, vec2(0.5, UV.y)).a;
//	 //* textureLod(TEXTURE, UV, blur).a;
//	vec4 output_color = vec4(temp_col, tex_alpha * alpha);
	 


//uniform sampler2D noise_tex;
//uniform sampler2D gradient_tex;
//
//uniform vec4 brighter_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
//uniform vec4 middle_color : source_color  = vec4(1.0, 0.56, 0.0, 1.0);
//uniform vec4 darker_color : source_color  = vec4(0.64, 0.2, 0.05, 1.0);
//
//uniform float spread : hint_range(0.0, 1.0) = 0.5;

//void fragment()
//{
//
//	float noise_value = texture(noise_tex, UV + vec2(0.0, TIME)).x;
//	// The .yx swizzle is when using the built in horizontal gradient texture. If you have a vertical gradient texture remove .yx
//	float gradient_value = texture(gradient_tex, UV.yx).x;
//
//	gradient_value -= smoothstep(spread, spread + 0.5, length(UV + vec2(-0.5, -0.5)) / spread);
//
//	float step1 = step(noise_value, gradient_value);
//	float step2 = step(noise_value, gradient_value - 0.2);
//	float step3 = step(noise_value, gradient_value - 0.4);
//
//	vec3 bd_color = mix(brighter_color.rgb, darker_color.rgb, step1 - step2);
//
//	vec4 color = vec4(bd_color, step1);
//	color.rgb = mix(color.rgb, middle_color.rgb, step2 - step3);
//
//	COLOR = color;
//}