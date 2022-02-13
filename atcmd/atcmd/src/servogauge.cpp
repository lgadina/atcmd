#include <servogauge.h>
#include <Adafruit_PWMServoDriver.h>

#define SERVOMIN  150 // This is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX  600 // This is the 'maximum' pulse length count (out of 4096)

ServoGauge::ServoGauge(Adafruit_PWMServoDriver *display, const uint8_t servoNum, const uint16_t fromLow, const uint16_t fromHigh, const uint8_t maxAngle, const bool reverse)
{
  this->valLow = fromLow;
  this->valHigh = fromHigh;
  this->servoNum = servoNum;
  this->display = display;
  this->value = 0;  
  this->maxAngle = maxAngle;
  this->reverse = reverse;
};

void ServoGauge::init() {
  setValue(0);
}

uint16_t ServoGauge::getValue() {
    return value;
}

void ServoGauge::setMaxValue(const uint16_t val)
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

uint16_t ServoGauge::getMaxValue()
{
  return valHigh;
}


void ServoGauge::setPercent(const uint8_t percent) {
  uint32_t val = valLow + ((uint32_t)(valHigh - valLow) * percent) / 100;
  setValue(val);
}

void ServoGauge::Draw()
{
   setAngle(currentPosition);
};

uint16_t ServoGauge::calcPosition(const uint16_t val)
{
  uint16_t _val = (val < valHigh) ? val : valHigh;
  uint16_t position = map(_val, valLow, valHigh, 0, maxAngle);
  if (reverse) position = maxAngle - position;
  return position;
};

void ServoGauge::invalidate()
{
  this->currentPosition = calcPosition(value);
  Draw();
}

void ServoGauge::setValue(const uint16_t val)
{
  if (val != value)
  {
    value = val;
    invalidate();
  }
};


 void ServoGauge::setServoPulse(double pulse) {

  double pulselength;
  pulselength = 1000000;   // 1,000,000 us per second
  pulselength /= 50;   // 50 Hz
  pulselength /= 4096;  // 12 bits of resolution
  pulse *= 1000;
  pulse /= pulselength;
  display->setPWM(servoNum, 0, pulse);
 }

 void ServoGauge::setAngle(int Angle) {     
  double pulse = Angle;
  pulse = pulse/90 + 0.5;
     setServoPulse (pulse*0.915);
 }