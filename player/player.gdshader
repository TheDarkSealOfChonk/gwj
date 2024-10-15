shader_type canvas_item;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float dissolve_amount;
uniform float dissolve_speed;
uniform float flicker_amount;
uniform float flicker_speed;
uniform vec2 scroll_speed;
uniform vec4 color_tint;
uniform vec3 chosen_color;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color1 = texture(texture1, uv);
    vec4 color2 = texture(texture2, uv);
    
    // Dissolvenza
    float dissolve_value = sin(TIME * dissolve_speed) * 0.5 + 0.5;
    dissolve_value = clamp(dissolve_value, 0.0, 1.0);
    
    // Sfarfallio
    float flicker_value = sin(TIME * flicker_speed) * 0.5 + 0.5;
    flicker_value = clamp(flicker_value, 0.0, 1.0);
    flicker_value = mix(1.0 - flicker_amount, 1.0 + flicker_amount, flicker_value);
    
    // Scorrimento
    vec2 scroll_offset = vec2(uv.x + scroll_speed.x * TIME, uv.y + scroll_speed.y * TIME);
    vec4 scroll_color = texture(texture2, scroll_offset);
    
    // Cambio colore
    vec4 chosen_color_tinted = vec4(chosen_color, 1.0) * color_tint;
    vec4 tinted_color = scroll_color * chosen_color_tinted;
    
    vec4 final_color = mix(color1, tinted_color, dissolve_value * flicker_value * dissolve_amount);
    
    COLOR = final_color;
}