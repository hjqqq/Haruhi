//
//  SDMatrix.h
//  Haruhi
//
//  Created by Sylvain Defresne on 29/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#ifndef HARUHI_MATHS_SDMATRIX_H
#define HARUHI_MATHS_SDMATRIX_H

#include "SDVector.h"

class mat2 {
public:
  union {
    const float v[4];
    struct {
      vec2 v0;
      vec2 v1;
    };
  };

  static const mat2 I;

  mat2(vec2 v0, vec2 v1): v0(v0), v1(v1) {}
};

class mat3 {
public:
  union {
    const float v[9];
    struct {
      vec3 v0;
      vec3 v1;
      vec3 v2;
    };
  };

  static const mat3 I;

  mat3(vec3 v0, vec3 v1, vec3 v2): v0(v0), v1(v1), v2(v2) {}
};

class mat4 {
public:
  union {
    const float v[16];
    struct {
      vec4 v0;
      vec4 v1;
      vec4 v2;
      vec4 v3;
    };
  };

  static const mat4 I;

  mat4(vec4 v0, vec4 v1, vec4 v2, vec4 v3): v0(v0), v1(v1), v2(v2), v3(v3) {}
};

vec4 operator *(mat4 lhs, vec4 rhs);
mat4 operator *(mat4 lhs, mat4 rhs);

mat4 BuildRotationAxisXMatrix(float theta);
mat4 BuildRotationAxisYMatrix(float theta);
mat4 BuildRotationAxisZMatrix(float theta);

mat4 BuildTranslationMatrix(vec3 translation);

mat4 BuildPerspectiveMatrix(float fov, float aspectRatio, float zNear, float zFar);

#endif
