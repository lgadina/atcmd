#include "gauges.h"
#include <LCDWIKI_GUI.h>
#include <SSD1283A.h>
#include "colors.h"

const XYPos tgCoeff[] PROGMEM = {{-127, 0},
                                 {-127, 2},
                                 {-127, 4},
                                 {-127, 7},
                                 {-127, 9},
                                 {-127, 11},
                                 {-126, 13},
                                 {-126, 15},
                                 {-126, 18},
                                 {-125, 20},
                                 {-125, 22},
                                 {-125, 24},
                                 {-124, 26},
                                 {-124, 29},
                                 {-123, 31},
                                 {-123, 33},
                                 {-122, 35},
                                 {-121, 37},
                                 {-121, 39},
                                 {-120, 41},
                                 {-119, 43},
                                 {-119, 46},
                                 {-118, 48},
                                 {-117, 50},
                                 {-116, 52},
                                 {-115, 54},
                                 {-114, 56},
                                 {-113, 58},
                                 {-112, 60},
                                 {-111, 62},
                                 {-110, 64},
                                 {-109, 65},
                                 {-108, 67},
                                 {-107, 69},
                                 {-105, 71},
                                 {-104, 73},
                                 {-103, 75},
                                 {-101, 76},
                                 {-100, 78},
                                 {-99, 80},
                                 {-97, 82},
                                 {-96, 83},
                                 {-94, 85},
                                 {-93, 87},
                                 {-91, 88},
                                 {-90, 90},
                                 {-88, 91},
                                 {-87, 93},
                                 {-85, 94},
                                 {-83, 96},
                                 {-82, 97},
                                 {-80, 99},
                                 {-78, 100},
                                 {-76, 101},
                                 {-75, 103},
                                 {-73, 104},
                                 {-71, 105},
                                 {-69, 107},
                                 {-67, 108},
                                 {-65, 109},
                                 {-64, 110},
                                 {-62, 111},
                                 {-60, 112},
                                 {-58, 113},
                                 {-56, 114},
                                 {-54, 115},
                                 {-52, 116},
                                 {-50, 117},
                                 {-48, 118},
                                 {-46, 119},
                                 {-43, 119},
                                 {-41, 120},
                                 {-39, 121},
                                 {-37, 121},
                                 {-35, 122},
                                 {-33, 123},
                                 {-31, 123},
                                 {-29, 124},
                                 {-26, 124},
                                 {-24, 125},
                                 {-22, 125},
                                 {-20, 125},
                                 {-18, 126},
                                 {-15, 126},
                                 {-13, 126},
                                 {-11, 127},
                                 {-9, 127},
                                 {-7, 127},
                                 {-4, 127},
                                 {-2, 127},
                                 {0, 127},
                                 {2, 127},
                                 {4, 127},
                                 {7, 127},
                                 {9, 127},
                                 {11, 127},
                                 {13, 126},
                                 {15, 126},
                                 {18, 126},
                                 {20, 125},
                                 {22, 125},
                                 {24, 125},
                                 {26, 124},
                                 {29, 124},
                                 {31, 123},
                                 {33, 123},
                                 {35, 122},
                                 {37, 121},
                                 {39, 121},
                                 {41, 120},
                                 {43, 119},
                                 {46, 119},
                                 {48, 118},
                                 {50, 117},
                                 {52, 116},
                                 {54, 115},
                                 {56, 114},
                                 {58, 113},
                                 {60, 112},
                                 {62, 111},
                                 {64, 110},
                                 {65, 109},
                                 {67, 108},
                                 {69, 107},
                                 {71, 105},
                                 {73, 104},
                                 {75, 103},
                                 {76, 101},
                                 {78, 100},
                                 {80, 99},
                                 {82, 97},
                                 {83, 96},
                                 {85, 94},
                                 {87, 93},
                                 {88, 91},
                                 {90, 90},
                                 {91, 88},
                                 {93, 87},
                                 {94, 85},
                                 {96, 83},
                                 {97, 82},
                                 {99, 80},
                                 {100, 78},
                                 {101, 76},
                                 {103, 75},
                                 {104, 73},
                                 {105, 71},
                                 {107, 69},
                                 {108, 67},
                                 {109, 65},
                                 {110, 64},
                                 {111, 62},
                                 {112, 60},
                                 {113, 58},
                                 {114, 56},
                                 {115, 54},
                                 {116, 52},
                                 {117, 50},
                                 {118, 48},
                                 {119, 46},
                                 {119, 43},
                                 {120, 41},
                                 {121, 39},
                                 {121, 37},
                                 {122, 35},
                                 {123, 33},
                                 {123, 31},
                                 {124, 29},
                                 {124, 26},
                                 {125, 24},
                                 {125, 22},
                                 {125, 20},
                                 {126, 18},
                                 {126, 15},
                                 {126, 13},
                                 {127, 11},
                                 {127, 9},
                                 {127, 7},
                                 {127, 4},
                                 {127, 2},
                                 {127, 0}};

Gauge90::Gauge90(SSD1283A_GUI *display, const uint8_t radius, const uint8_t x, const uint8_t y, const uint16_t fromLow, const uint16_t fromHigh)
{
  this->centerX = x;
  this->centerY = y;
  this->radius = radius;
  this->valLow = fromLow;
  this->valHigh = fromHigh;
  this->oldCoo = calcCoord(0);
  this->display = display;
  this->value = 0;
  this->isDrawing = false;
};

XYPos Gauge90::calcCoord(const uint8_t position)
{
  uint16_t cw = pgm_read_word(&tgCoeff[position]);
  XYPos w;
  w.x = ((radius - 3) * (int8_t)cw) / 127;
  w.y = ((radius - 3) * (int16_t)(cw >> 8)) / 127;
  return w;
};

void Gauge90::setMaxValue(const uint16_t val)
{
  if (val != valHigh)
  {
    if (val < valLow)
    {
      valHigh = valLow;
    }
    else
    {
      valHigh = val;
    }
    invalidate();
  }
};

uint16_t Gauge90::getMaxValue()
{
  return valHigh;
}

void Gauge90::drawSemiCircle()
{
  this->display->Draw_Circle_Helper(centerX, centerY, radius, 1);
};

void Gauge90::setPercent(const uint8_t percent) {
  uint32_t val = valLow + ((uint32_t)(valHigh - valLow) * percent) / 100;
  setValue(val);
}

void Gauge90::Draw()
{
  if (!isDrawing)
  {
    this->display->Set_Draw_color(RED);
    drawSemiCircle();
    isDrawing = true;
  }
  this->display->Set_Draw_color(BLACK);
  this->display->Draw_Line(centerX, centerY, centerX + oldCoo.x, centerY - oldCoo.y);
  this->display->Set_Draw_color(GREEN);
  this->display->Draw_Line(centerX, centerY, centerX + Coo.x, centerY - Coo.y);
};

uint8_t Gauge90::calcPosition(const uint16_t val)
{
  uint16_t _val = (val < valHigh) ? val : valHigh;
  uint8_t position = map(_val, valLow, valHigh, 0, 90);
  if (position > 90)
    position = 90;
  return position;
};

void Gauge90::invalidate()
{
  uint8_t position = calcPosition(value);
  Coo = calcCoord(position);
  Draw();
  oldCoo.x = Coo.x;
  oldCoo.y = Coo.y;
}

void Gauge90::setValue(const uint16_t val)
{
  if (val != value)
  {
    value = val;
    invalidate();
  }
};

Gauge180::Gauge180(SSD1283A_GUI *display, const uint8_t radius, const uint8_t x, const uint8_t y, const uint16_t fromLow, const uint16_t fromHigh) : Gauge90(display, radius, x, y, fromLow, fromHigh){};

void Gauge180::drawSemiCircle()
{
  Gauge90::drawSemiCircle();
  this->display->Draw_Circle_Helper(centerX, centerY, radius, 2);
}

uint8_t Gauge180::calcPosition(const uint16_t val)
{
  uint16_t _val = (val < valHigh) ? val : valHigh;
  uint8_t position = map(_val, valLow, valHigh, 0, 180);
  if (position > 180)
    position = 180;
  return position;
}