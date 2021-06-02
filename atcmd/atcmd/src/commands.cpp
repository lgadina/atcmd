#include <Arduino.h>
#include "commands.h"


int bufToInt(const InputBuffer buffer, byte startPos, byte maxLen, char val)
{
  char *tmpBuf = (char *)malloc(maxLen);
  memccpy(tmpBuf, &buffer[startPos], val, maxLen);
  int t = strtol(tmpBuf, NULL, 10);
  free(tmpBuf);
  return t;
}

void printEcho(const char *buf)
{
  Serial.print('+');
  Serial.print(buf);
  Serial.print(':');
}