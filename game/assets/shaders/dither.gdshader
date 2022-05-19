// Shader that uses a screen-size transparency image as a mask to discard pixels that would otherwise be drawn,
// useful for foreground objects, particularly ones that would normally obstruct the view of important gameplay elements
// such as sprite-based viewmodels in a doom-style FPS, etc.
shader_type canvas_item;

uniform sampler2D texture_albedo : hint_albedo;
uniform bool invert;

void fragment() {

vec4 tex = texture(TEXTURE, UV);

float tex_alpha = tex.a;

vec4 albedo_tex = texture(texture_albedo, UV);

float albedo_alpha = albedo_tex.a;



if (tex_alpha < float(1)) discard; //discard already-transparent pixels first, this step is crucial to avoid covering your entire screen with your mask pattern`

if (tex_alpha == albedo_alpha && invert == bool(false)) discard; // if invert is false, discard all non-transparent pixels that line up with non-transparent pixels in the mask`

if (tex_alpha > albedo_alpha && invert == bool(true)) discard; // if invert is true, discard all non-transparent pixels that line up with transparent pixels in the mask`

}