shader_type canvas_item;

varying vec2 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}


void fragment() {
    vec4 water_noise = vec4(texture(TEXTURE, vec2(mod(world_position.x/1920.0, 1.0), mod(world_position.y/1080.0, 1.0))));
    COLOR = water_noise;
}

