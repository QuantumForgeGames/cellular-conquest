shader_type canvas_item;

uniform sampler2D color_ramp;
uniform sampler2D general_noise;
varying vec2 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
    //world_position = (CANVAS_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123)) * clamp(0.75+((sin(TIME) +0.0) /4.0f), 0.5, 1.0);
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}

void fragment() {
    
    
	//float worley = worley(UV + TIME * 0.08f, 3.0, 5.0);
    float scale = 0.0005f;
    float worley = worley(world_position * scale, 3.0, 5.0);
    //float worley = worley(UV, 3.0, 5.0);
    vec4 water_color = texture(color_ramp, vec2(worley));
    vec4 water_fade = texture(TEXTURE, UV);
    vec4 water_noise = vec4(texture(general_noise, vec2(mod(world_position.x/1920.0, 1.0), mod(world_position.y/1080.0, 1.0))).rgb, water_color.a);
    // * vec4(vec3(worley), 1.0);

    COLOR = water_noise;
    //COLOR = water_color * water_noise * water_fade;
}

