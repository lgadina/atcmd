#ifndef ETS_SERVOGAUGES
#define ETS_SERVOGAUGES

#include <Arduino.h>
#include <Adafruit_PWMServoDriver.h>

class ServoGauge
{
protected:
    uint16_t currentPosition;
    uint8_t servoNum, maxAngle;
    uint16_t value;
    uint16_t valLow, valHigh;
    boolean reverse;
    Adafruit_PWMServoDriver *display;

protected:
    virtual uint16_t calcPosition(const uint16_t val);
    void invalidate();
    void setServoPulse(double pulse);
public:
    ServoGauge(Adafruit_PWMServoDriver *display, const uint8_t servoNum,  const uint16_t fromLow, const uint16_t fromHigh, const uint8_t maxAngle, const bool reverse);
    void Draw();
    void setPercent(const uint8_t percent);
    void setValue(const uint16_t val);
    void setMaxValue(const uint16_t val);
    uint16_t getValue();
    void setAngle(int Angle);
    void init();
    uint16_t getMaxValue();
};

#endif