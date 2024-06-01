shader_type canvas_item;

uniform sampler2D knockback_gradient;
uniform sampler2D knockback_noise;


void fragment() {
	float x_ = UV.x - 0.5;
    float y_ = UV.y - 0.5;

    float h_ = sqrt(pow(x_, 2) + pow(y_, 2));
    vec3 unit_ = vec3(x_/h_, y_/h_, h_/h_);

    vec2 uv;

    uv.x = h_ * TEXTURE_PIXEL_SIZE.x * (float(textureSize(knockback_gradient, 0).x) *0.025);
    
    vec4 tex = texture(knockback_noise, UV);
    vec4 grad = texture(knockback_gradient, UV);
    //COLOR = vec4(grad.r, grad.g, grad.b, grad.a);
    COLOR = grad;
}

