//
//  SDVector.h
//  Haruhi
//
//  Created by Sylvain Defresne on 29/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#ifndef HARUHI_MATHS_SDVECTOR_H
#define HARUHI_MATHS_SDVECTOR_H

#import <cmath>

#include "SDVectorPrepare.h"

class vec2;
class vec3;
class vec4;

#define VEC2_SWIZZLE(_) \
  _(vec2, vec2, x, y) \
  _(vec2, vec2, y, x) \

#define VEC3_SWIZZLE(_) \
  _(vec3, vec3, x, y, z) \
  _(vec3, vec3, y, z, x) \
  _(vec3, vec3, z, x, y)

#define VEC4_SWIZZLE(_) \
  _(vec4, vec4, x, y, z, w) \
  _(vec4, vec4, y, z, w, x) \
  _(vec4, vec4, z, w, x, y) \
  _(vec4, vec4, w, x, y, z)

class vec2 {
public:
  union {
    const float v[2];
    struct {
      const float x;
      const float y;
    };
  };

  vec2(float x, float y): x(x), y(y) {}
  vec2(const float v[2]): x(v[0]), y(v[1]) {}

  VEC2_SWIZZLE(DEF_SWIZZLE)
};

class vec3 {
public:
  union {
    const float v[3];
    struct {
      const float x;
      const float y;
      const float z;
    };
  };

  vec3(vec2 v, float z): x(v.x), y(v.y), z(z) {}
  vec3(float x, float y, float z): x(x), y(y), z(z) {}
  vec3(const float v[3]): x(v[0]), y(v[1]), z(v[2]) {}

  VEC3_SWIZZLE(DEF_SWIZZLE)
};

class vec4 {
public:
  union {
    const float v[4];
    struct {
      const float x;
      const float y;
      const float z;
      const float w;
    };
  };

  vec4(vec3 v, float w): x(v.x), y(v.y), z(v.z), w(w) {}
  vec4(vec2 v, float z, float w): x(v.x), y(v.y), z(z), w(w) {}
  vec4(float x, float y, float z, float w): x(x), y(y), z(z), w(w) {}
  vec4(const float v[4]): x(v[0]), y(v[1]), z(v[2]), w(v[4]) {}

  VEC4_SWIZZLE(DEF_SWIZZLE)
};

VECTOR_IMPLEMENTATION(2)
VECTOR_IMPLEMENTATION(3)
VECTOR_IMPLEMENTATION(4)

#undef VEC4_SWIZZLE
#undef VEC3_SWIZZLE
#undef VEC2_SWIZZLE

#include "SDVectorCleanup.h"

#endif
