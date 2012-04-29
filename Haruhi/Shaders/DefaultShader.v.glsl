#version 150

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 color;

smooth out vec4 theColor;

uniform mat4 perspectiveMatrix;

void main()
{
  vec4 worldPos = position;
  gl_Position = perspectiveMatrix * worldPos;
  theColor = color;
}
