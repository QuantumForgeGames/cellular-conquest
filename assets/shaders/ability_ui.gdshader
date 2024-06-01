shader_type canvas_item;

uniform float percent = 0.3;
uniform float grey_factor = 0.2;

void fragment() {
	COLOR.rgb = COLOR.rgb * grey_factor * (1. + step(percent, 1. - UV.y));
}
