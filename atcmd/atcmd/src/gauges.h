#ifndef ETS_GAUGES
#define ETS_GAUGES

#include <Arduino.h>
#include <LCDWIKI_GUI.h>
#include <SSD1283A.h>

typedef struct
{
  int8_t x;
  int8_t y;
} XYPos;


class Gauge90
{
protected:
  uint8_t centerX, centerY, radius;
  uint16_t value;
  boolean isDrawing;
  XYPos Coo, oldCoo;
  XYPos calcCoord(const uint8_t position);
  uint16_t valLow, valHigh;
  SSD1283A_GUI *display;
protected:
  virtual void drawSemiCircle();
  virtual uint8_t calcPosition(const uint16_t val);
  void invalidate();
public:
  Gauge90(SSD1283A_GUI *display, const uint8_t radius, const uint8_t x, const uint8_t y, const uint16_t fromLow, const uint16_t fromHigh);
  void Draw();
  void setPercent(const uint8_t percent);
  void setValue(const uint16_t val);
  void setMaxValue(const uint16_t val);
  uint16_t getMaxValue();
};


class Gauge180 : public Gauge90
{
protected:
  void drawSemiCircle();
  uint8_t calcPosition(const uint16_t val);

public:
  Gauge180(SSD1283A_GUI *display, const uint8_t radius, const uint8_t x, const uint8_t y, const uint16_t fromLow, const uint16_t fromHigh);
};
#endif