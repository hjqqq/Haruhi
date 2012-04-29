//
//  SDMacros.h
//  Haruhi
//
//  Created by Sylvain Defresne on 29/04/2012.
//  Copyright (c) 2012 Sylvain Defresne. All rights reserved.
//

#ifndef HARUHI_BASE_SDMACROS_H
#define HARUHI_BASE_SDMACROS_H

#define VALUE(...)    __VA_ARGS__
#define COMMA(...)    ,

// Concatenate up-to N token (the macro could be extended to
// a larger value of N, currently fixed at 4).
#define CONCATN(...) CONCATN_IMPL(__VA_ARGS__, , , ,)
#define CONCATN_IMPL(_1, _2, _3, _4, ...) _1 ## _2 ## _3 ## _4

// This macro will expand to _(__VA_ARGS__) if N is non-zero,
// otherwise it will expand to nothing (N in range 0 to 3).
#define IF(N, _, ...) \
  IF_ ## N(_, __VA_ARGS__)

#define IF_3(_, ...)  _(__VA_ARGS__)
#define IF_2(_, ...)  _(__VA_ARGS__)
#define IF_1(_, ...)  _(__VA_ARGS__)
#define IF_0(_, ...)

// This macro will expand to _(0, __VA_ARGS__) _(1, __VA_ARGS__) ...
// (N in range 0 to 4).
#define REPEAT(N, _, ...) \
  REPEAT_ ## N(_, __VA_ARGS__)

#define REPEAT_4(_, ...) REPEAT_3(_, __VA_ARGS__) _(3, __VA_ARGS__)
#define REPEAT_3(_, ...) REPEAT_2(_, __VA_ARGS__) _(2, __VA_ARGS__)
#define REPEAT_2(_, ...) REPEAT_1(_, __VA_ARGS__) _(1, __VA_ARGS__)
#define REPEAT_1(_, ...) REPEAT_0(_, __VA_ARGS__) _(0, __VA_ARGS__)
#define REPEAT_0(_, ...)

// This macro will expand to its N-th parameter (N in range 0 to 4).
#define ACCESS(N, ...) \
  ACCESS_ ## N(__VA_ARGS__)

#define ACCESS_3(_0, _1, _2, _3, ...) _3
#define ACCESS_2(_0, _1, _2, ...)     _2
#define ACCESS_1(_0, _1, ...)         _1
#define ACCESS_0(_0, ...)             _0

#endif
