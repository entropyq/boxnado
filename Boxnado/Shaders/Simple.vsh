//
//  Simple.vsh
//  Boxnado
//
//  Created by Matt Loflin on 7/13/16.
//  Copyright © 2016 Awesomeness. All rights reserved.
//

//precision lowp float;

attribute vec4 a_position;
attribute vec3 a_normal;

uniform mat4 u_mvp_matrix;
uniform mat3 u_normal_matrix;
uniform vec4 u_color;
uniform bool u_toon_coloring;

varying vec4 v_color;

void main()
{
    vec3 eye_normal = normalize(u_normal_matrix * a_normal);
    vec3 light_vector = vec3(0.0, 0.0, -1.0);
    float nDotVP = max(0.0, dot(eye_normal, normalize(light_vector)));

    if (u_toon_coloring) {
        if (nDotVP > 0.95) {
            v_color = u_color * vec4(1.0,1.0,1.0,1.0);
        } else if (nDotVP > 0.7) {
            v_color = u_color * vec4(0.7,0.7,0.7,1.0);
        } else if (nDotVP > 0.5) {
            v_color = u_color * vec4(0.5,0.5,0.5,1.0);
        } else if (nDotVP > 0.25) {
            v_color = u_color * vec4(0.3,0.3,0.3,1.0);
        } else {
            v_color = u_color * vec4(0.1,0.1,0.1,1.0);
        }
    } else {
        v_color = u_color * nDotVP;
    }

    gl_Position = u_mvp_matrix * a_position;
}