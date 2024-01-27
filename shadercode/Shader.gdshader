shader_type canvas_item;
uniform float intensity : hint_range(0.0, 1.0) = 0;

float random(vec2 uv) { //gets random float between 0 and 1 from godot shaders
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void checkScore(int score){

}
void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    // Called for every pixel the material is visible on
	vec2 distortedUV = UV;
	distortedUV.x += distortedUV.y *intensity * random(distortedUV); //distorts the screen from random noise, change to swirl
	vec4 pixels = texture(TEXTURE, distortedUV); //applies texture distortion
	
	float redHue = intensity * 0.5; //adds a red hue multiplied by the intensity
	pixels.r += redHue;
	COLOR = pixels;
	
}

// void light() {
//     Called for every pixel for every light affecting the CanvasItem.
//     Uncomment to replace the default light processing function with this one.
// }

