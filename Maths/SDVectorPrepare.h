//
//  SDVectorPrepare.h
//  Haruhi
//
//  Created by Sylvain Defresne on 29/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#include "Base/SDMacros.h"

#define SWIZZLE_IMPL(T1, T2, NAME, IMPL, ...) \
  inline T2 NAME(T1, __VA_ARGS__)() const \
  IMPL(T2, __VA_ARGS__)

#define DEF_SWIZZLE_NAME(T1, ...) CONCATN(__VA_ARGS__)
#define IMP_SWIZZLE_NAME(T1, ...) T1::DEF_SWIZZLE_NAME(T, __VA_ARGS__)

#define DEF_SWIZZLE_IMPL(T2, ...) ;
#define IMP_SWIZZLE_IMPL(T2, ...) { return T2(__VA_ARGS__); }

#define DEF_SWIZZLE(T1, T2, ...) \
  SWIZZLE_IMPL(T1, T2, DEF_SWIZZLE_NAME, DEF_SWIZZLE_IMPL, __VA_ARGS__)

#define IMP_SWIZZLE(T1, T2, ...) \
  SWIZZLE_IMPL(T1, T2, IMP_SWIZZLE_NAME, IMP_SWIZZLE_IMPL, __VA_ARGS__)

#define VECTOR_COMPONENT(N, VECTOR) VECTOR.ACCESS(N, x, y, z, w)
#define SCALAR_COMPONENT(N, SCALAR) SCALAR

#define VECTOR_OPERATION(N, SELECTOR, VALUE, OP, LHS, RHS, COMPONENT_LHS, COMPONENT_RHS) \
  IF(N, SELECTOR, VALUE) COMPONENT_LHS(N, LHS) OP COMPONENT_RHS(N, RHS)

#define VECTOR_VECTOR_OPERATOR(OP, DIM) \
  inline vec ## DIM operator OP(vec ## DIM lhs, vec ## DIM rhs) { \
    return vec ## DIM(REPEAT(DIM, VECTOR_OPERATION, \
      COMMA, ~, OP, lhs, rhs, VECTOR_COMPONENT, VECTOR_COMPONENT)); \
  }

#define VECTOR_SCALAR_OPERATOR(OP, DIM) \
  inline vec ## DIM operator OP(vec ## DIM lhs, float rhs) { \
    return vec ## DIM(REPEAT(DIM, VECTOR_OPERATION, \
      COMMA, ~, OP, lhs, rhs, VECTOR_COMPONENT, SCALAR_COMPONENT)); \
  }

#define SCALAR_VECTOR_OPERATOR(OP, DIM) \
  inline vec ## DIM operator OP(float lhs, vec ## DIM rhs) { \
    return vec ## DIM(REPEAT(DIM, VECTOR_OPERATION, \
      COMMA, ~, OP, lhs, rhs, SCALAR_COMPONENT, VECTOR_COMPONENT)); \
  }

#define VECTOR_FUNCTION(DIM) \
  inline float dot(vec ## DIM lhs, vec ## DIM rhs) { \
    return REPEAT(DIM, VECTOR_OPERATION, \
      VALUE, +, *, lhs, rhs, VECTOR_COMPONENT, VECTOR_COMPONENT); \
  } \
  inline float normsq(vec ## DIM v) { \
    return dot(v, v); \
  } \
  inline float norm(vec ## DIM v) { \
    return sqrt(normsq(v)); \
  } \
  inline vec ## DIM normalized(vec ## DIM v) { \
    return v / norm(v); \
  }

#define VECTOR_IMPLEMENTATION(DIM) \
  VEC ## DIM ## _SWIZZLE(IMP_SWIZZLE) \
  VECTOR_VECTOR_OPERATOR(+, DIM) \
  VECTOR_VECTOR_OPERATOR(-, DIM) \
  SCALAR_VECTOR_OPERATOR(*, DIM) \
  VECTOR_SCALAR_OPERATOR(*, DIM) \
  VECTOR_SCALAR_OPERATOR(/, DIM) \
  VECTOR_FUNCTION(DIM)
