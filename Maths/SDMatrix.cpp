//
//  SDMatrix.cpp
//  Haruhi
//
//  Created by Sylvain Defresne on 29/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#include "SDMatrix.h"

#include <cmath>

const mat2 mat2::I =
mat2(vec2(1.0f, 0.0f),
     vec2(0.0f, 1.0f));

const mat3 mat3::I =
mat3(vec3(1.0f, 0.0f, 0.0f),
     vec3(0.0f, 1.0f, 0.0f),
     vec3(0.0f, 0.0f, 1.0f));

const mat4 mat4::I =
mat4(vec4(1.0f, 0.0f, 0.0f, 0.0f),
     vec4(0.0f, 1.0f, 0.0f, 0.0f),
     vec4(0.0f, 0.0f, 1.0f, 0.0f),
     vec4(0.0f, 0.0f, 0.0f, 1.0f));

vec4 operator *(mat4 lhs, vec4 rhs) {
  float values[4] = { 0.0f, 0.0f, 0.0f, 0.0f };
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      values[i] += lhs.v[4 * j + i] * rhs.v[j];
    }
  }
  return vec4(values[0], values[1], values[2], values[3]);
}

mat4 operator *(mat4 lhs, mat4 rhs) {
  return mat4(lhs * rhs.v0,
              lhs * rhs.v1,
              lhs * rhs.v2,
              lhs * rhs.v3);
}

mat4 BuildRotationAxisXMatrix(float theta) {
  const float cos = cosf(theta), sin = sinf(theta);
  return mat4(vec4(1.0f, 0.0f, 0.0f, 0.0f),
              vec4(0.0f, +cos, -sin, 0.0f),
              vec4(0.0f, +sin, +cos, 0.0f),
              vec4(0.0f, 0.0f, 0.0f, 1.0f));
}

mat4 BuildRotationAxisYMatrix(float theta) {
  const float cos = cosf(theta), sin = sinf(theta);
  return mat4(vec4(+cos, 0.0f, +sin, 0.0f),
              vec4(0.0f, 1.0f, 0.0f, 0.0f),
              vec4(-sin, 0.0f, +cos, 0.0f),
              vec4(0.0f, 0.0f, 0.0f, 1.0f));
}

mat4 BuildRotationAxisZMatrix(float theta) {
  const float cos = cosf(theta), sin = sinf(theta);
  return mat4(vec4(+cos, -sin, 0.0f, 0.0f),
              vec4(+sin, +cos, 0.0f, 0.0f),
              vec4(0.0f, 0.0f, 1.0f, 0.0f),
              vec4(0.0f, 0.0f, 0.0f, 1.0f));
}

mat4 BuildTranslationMatrix(vec3 translation) {
  return mat4(vec4(1.0f, 0.0f, 0.0f, 0.0f),
              vec4(0.0f, 1.0f, 0.0f, 0.0f),
              vec4(0.0f, 0.0f, 1.0f, 0.0f),
              vec4(translation, 1.0f));
}

mat4 BuildPerspectiveMatrix(float fov, float aspectRatio, float zNear, float zFar) {
  const float invZDelta = 1.0f / (zNear - zFar);
  const float scale = 1.0f / tanf(fov * M_PI / 180.f / 2.0f);
  return mat4(vec4(scale * aspectRatio, 0.0f, 0.0f, 0.0f),
              vec4(0.0f, scale, 0.0f, 0.0f),
              vec4(0.0f, 0.0f, (zNear + zFar) * invZDelta, -1.0f),
              vec4(0.0f, 0.0f, 2.0f * zNear * zFar * invZDelta, 0.0f));
}
