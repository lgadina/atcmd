//#define LCDI2C
#define TFT130
#define TM1638_D

#include <Arduino.h>
#include "ets2data.h"
#include <commands.h>
#ifdef ATMEGA32U4
#include "Keyboard.h"
#endif

#ifdef TM1638_D
#include <TM1638plus.h>
#endif

#ifdef LCDI2C
#include <LiquidCrystal_I2C.h>
#endif

#ifdef TFT130
#include <LCDWIKI_GUI.h>
#include "SSD1283A.h" //Hardware-specific library
#include "icons.h"
#include "colors.h"
#include "gauges.h"
#define MAX_SPD 140
#define MAX_RPM 3000
#endif

//#define DEBUG

#ifdef TM1638_D
TM1638plus tmb(4, 5, 6, false);
bool tmbReseted = false;
#endif


static const uint16_t PGN_ENGINE_speed = 0xF004;       // SPN 190
static const uint16_t PGN_VEHICLE_speed = 0xFEF1;      // SPN 84. Cruise control SPN 86
static const uint16_t PGN_VEHICLE_odometer = 0xFEC1;   // SPN 917
static const uint16_t PGN_ENGINE_temperature = 0XFEEE; // SPN 110
static const uint16_t PGN_AIR_PRESSURE = 0xFEAE;       // SPN 1087 -reservoir 1, SPN 1088 reservoir 2,  8kPa / bit

#ifdef LCDI2C
LiquidCrystal_I2C lcd(0x3f, 16, 2);
#endif



#ifdef TFT130

#ifdef ATMEGA32U4
#define CS_D 10
#else
#define CS_D SS
#endif

SSD1283A_GUI mylcd(/*CS=10*/ CS_D, /*DC=*/8, /*RST=*/9, /*LED=*/7); //hardware spi,cs,cd,reset,led

Gauge180 speedometer(&mylcd, 30, 31, 31, 0, MAX_SPD);
Gauge180 tachometer(&mylcd, 30, 130 - 31, 31, 0, MAX_RPM);
Gauge90 fuelmeter(&mylcd, 20, 21, 60, 0, 1200);
Gauge90 airpressure(&mylcd, 20, 45, 60, 0, 140);
Gauge90 oilPressure(&mylcd, 20, 69, 60, 0, 120);
Gauge90 waterTemp(&mylcd, 20, 93, 60, 0, 1200);
Gauge90 oilTemp(&mylcd, 20, 117, 60, 0, 1200);
Gauge180 accumVoltage(&mylcd, 20, 21, 90, 220, 300);
Gauge90 brakeTemp(&mylcd, 20, 64, 90, 0, 2400);

Icon iconBrakeWarningDisp(&mylcd, iconBrakeWarn, 68, 130 - 11, RED);
Icon iconHandbrakeDisp(&mylcd, iconHandbrake, 51, 130 - 11, RED);
Icon iconLightHighBeamDisp(&mylcd, iconLightHighBeam, 34, 130 - 11, BLUE);
Icon iconLightLowBeamDisp(&mylcd, iconLightLowBeam, 17, 130 - 11, GREEN);
Icon iconParkingLightDisp(&mylcd, iconParkingLight, 0, 130 - 11, GREEN);
IconBack iconRightTurnDisp(&mylcd, iconLeftTurn, 102, 130 - 11, GREEN);
Icon iconLeftTurnDisp(&mylcd, iconLeftTurn, 85, 130 - 11, GREEN);
Icon iconAccumWarningDisp(&mylcd, iconAccumWarning, 0, 130 - 24, RED);
Icon iconWaterWarningDisp(&mylcd, iconWaterWarning, 17, 130 - 24, RED);
Icon iconOilWarningDisp(&mylcd, iconOilWarning, 34, 130 - 24, RED);
Icon iconCheckEngineDisp(&mylcd, iconCheckEngine, 51, 130 - 24, YELLOW);
Icon iconWheelWarningDisp(&mylcd, iconWheelWarning, 68, 130 - 24, YELLOW);
Icon iconTransmissionWarningDisp(&mylcd, iconTransmissionWarning, 85, 130 - 24, YELLOW);
Icon iconCruiseControlDisp(&mylcd, iconCruiseControl, 102, 130 - 24, GREEN);
Icon iconFuelWarningDisp(&mylcd, iconFuelWarning, 1, 37, RED);

void initDisplay()
{
  for (byte a = 0; a <= 100; a = a + 5)
  {
    tachometer.setPercent(a);
    speedometer.setPercent(a);
    fuelmeter.setPercent(a);
    oilPressure.setPercent(a);
    airpressure.setPercent(a);
    waterTemp.setPercent(a);
    oilTemp.setPercent(a);
    brakeTemp.setPercent(a);
    accumVoltage.setPercent(a);
    #ifdef TM1638_D
    tmb.setLED(a % 8, 1);
    tmb.displayASCII(a % 8, '8');
    #endif
  }
  for (byte a = 100; a > 0; a = a - 5)
  {
    tachometer.setPercent(a);
    speedometer.setPercent(a);
    fuelmeter.setPercent(a);
    oilPressure.setPercent(a);
    airpressure.setPercent(a);
    waterTemp.setPercent(a);
    oilTemp.setPercent(a);
    brakeTemp.setPercent(a);
    accumVoltage.setPercent(a);
    #ifdef TM1638_D
    tmb.setLED(a % 8, 0);
    tmb.displayASCII(a % 8, ' ');
    #endif
  }
  tachometer.setValue(0);
  speedometer.setValue(0);
  fuelmeter.setValue(0);
  oilPressure.setValue(0);
  airpressure.setValue(0);
  waterTemp.setValue(0);
  brakeTemp.setValue(0);
  oilTemp.setValue(0);
  accumVoltage.setValue(240);
}

#endif

InputBuffer inputBuffer;
ETS2Data ets2Data;
bool bufferReady;

byte pos = 0;
byte len = 0;
byte dispId = 0;
bool echo = 1;
unsigned long gadgetTime = 0;
unsigned long oldTime = 0;
boolean oldElectricEnabled = false;

void displayData(ETS2Data *data)
{

  if (oldElectricEnabled != data->electricEnabled)
  {
    if (data->electricEnabled)
    {
#ifdef TFT130
      initDisplay();
#endif
    }
#ifdef LCDI2C
    lcd.clear();
    digitalWrite(LED_BUILTIN, data->electricEnabled);
#endif
    oldElectricEnabled = data->electricEnabled;
  }

#ifdef LCDI2C
  char tmp[10];
#endif

  unsigned long tm = micros();
  word spd = (data->spd * 3.6) / 10;

#ifdef TFT130
  speedometer.setValue(data->electricEnabled ? spd : 0);
#endif

#ifdef LCDI2C
  itoa(spd, tmp, 10);
  lcd.setCursor(0, 0);
  lcd.print(tmp);
#endif

  spd = (data->cspd * 3.6) / 10;

#ifdef LCDI2C
  itoa(spd, tmp, 10);
  lcd.setCursor(0, 1);
  lcd.print(tmp);
  itoa(data->rpm, tmp, 10);
  lcd.setCursor(4, 0);
  lcd.print(tmp);
  itoa(data->fuel, tmp, 10);
  lcd.setCursor(9, 0);
  lcd.print(tmp);
  itoa(data->airPressure, tmp, 10);
  lcd.setCursor(13, 0);
  lcd.print(tmp);
  lcd.setCursor(4, 1);
  if (data->leftBlinkerLight)
  {
    lcd.print("<");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(5, 1);
  if (data->rightBlinkerLight)
  {
    lcd.print(">");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(6, 1);
  if (data->lightParking)
  {
    lcd.print("P");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(7, 1);
  if (data->lightLowBeam)
  {
    lcd.print("L");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(8, 1);
  if (data->lightHighBeam)
  {
    lcd.print("H");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(9, 1);
  if (data->parkingBracke)
  {
    lcd.print("X");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(10, 1);
  if (data->motorBrake)
  {
    lcd.print("M");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(11, 1);
  if (data->airPressureWarning)
  {
    lcd.print("A");
  }
  else
  {
    lcd.print(" ");
  }
  lcd.setCursor(12, 1);
  if (data->airPressureEmergency)
  {
    lcd.print("!");
  }
  else
  {
    lcd.print(" ");
  }
#endif

#ifdef TFT130
  tachometer.setValue(data->electricEnabled ? data->rpm : 0);
  fuelmeter.setValue(data->electricEnabled ? data->fuel : 0);
  airpressure.setValue(data->electricEnabled ? data->airPressure : 0);
  oilPressure.setValue(data->electricEnabled ? data->oilPressure : 0);
  waterTemp.setValue(data->electricEnabled ? data->waterTemp : 0);
  accumVoltage.setValue(data->electricEnabled ? data->accumVoltage : 0);
  brakeTemp.setValue(data->electricEnabled ? data->brakeTemp : 0);
  oilTemp.setValue(data->electricEnabled ? data->oilTemp : 0);
  //drawIcon(mylcd, iconBrakeWarn, 68, 130 - 11, data->airPressureWarning && data->electricEnabled ? RED : BLACK);
  iconBrakeWarningDisp.setValue(data->airPressureWarning && data->electricEnabled);
  #ifdef TM1638_D
  tmb.setLED(2, data->airPressureWarning && data->electricEnabled ? 1 : 0);
  #endif

  //drawIcon(mylcd, iconHandbrake, 51, 130 - 11, data->parkingBracke && data->electricEnabled ? RED : BLACK);
  iconHandbrakeDisp.setValue(data->parkingBracke && data->electricEnabled);
  #ifdef TM1638_D
  tmb.setLED(7, data->parkingBracke && data->electricEnabled ? 1 : 0);
  #endif

  // drawIcon(mylcd, iconLighHighBeam, 34, 130 - 11, data->lightHighBeam && data->lightHighBeam && data->electricEnabled ? BLUE : BLACK);
  iconLightHighBeamDisp.setValue(data->lightHighBeam && data->lightLowBeam && data->electricEnabled);

  // drawIcon(mylcd, iconLightLowBeam, 17, 130 - 11, data->lightLowBeam && data->electricEnabled ? GREEN : BLACK);
  iconLightLowBeamDisp.setValue(data->lightLowBeam && data->electricEnabled);

  // drawIcon(mylcd, iconParkingLight, 0, 130 - 11, data->lightParking ? GREEN : BLACK);
  iconParkingLightDisp.setValue(data->lightParking);
  // drawIconBack(mylcd, iconLeftTurn, 102, 130 - 11, data->rightBlinkerLight ? GREEN : BLACK);
  iconRightTurnDisp.setValue(data->rightBlinkerLight);
  #ifdef TM1638_D
  tmb.setLED(1, data->rightBlinkerLight ? 1 : 0);
  #endif
  // drawIcon(mylcd, iconLeftTurn, 85, 130 - 11, data->leftBlinkerLight ? GREEN : BLACK);
  iconLeftTurnDisp.setValue(data->leftBlinkerLight);
  #ifdef TM1638_D
  tmb.setLED(0, data->leftBlinkerLight ? 1 : 0);
  #endif

  // drawIcon(mylcd, iconAccumWarning, 0, 130 - 24, data->batteryVoltageWarning && data->electricEnabled ? RED : BLACK);
  iconAccumWarningDisp.setValue(data->batteryVoltageWarning && data->electricEnabled);
  // drawIcon(mylcd, iconWaterWarning, 17, 130 - 24, data->waterTempWaring && data->electricEnabled ? RED : BLACK);
  iconWaterWarningDisp.setValue(data->waterTempWaring && data->electricEnabled);
  // drawIcon(mylcd, iconOilWarning, 34, 130 - 24, data->oilPressureWarning && data->electricEnabled ? RED : BLACK);
  iconOilWarningDisp.setValue(data->oilPressureWarning && data->electricEnabled);
  // drawIcon(mylcd, iconCheckEngine, 51, 130 - 24, data->checkEngine && data->electricEnabled ? YELLOW : BLACK);
  iconCheckEngineDisp.setValue(data->checkEngine && data->electricEnabled);
  #ifdef TM1638_D
  tmb.setLED(3, data->checkEngine && data->electricEnabled ? 1 : 0);
  #endif
  // drawIcon(mylcd, iconWheelWarning, 68, 130 - 24, data->wheelWarning && data->electricEnabled ? YELLOW : BLACK);
  iconWheelWarningDisp.setValue(data->wheelWarning && data->electricEnabled);
  #ifdef TM1638_D
  tmb.setLED(4, data->wheelWarning && data->electricEnabled ? 1 : 0);
  #endif
  // drawIcon(mylcd, iconTransmissionWarning, 85, 130 - 24, data->transmissionWarning && data->electricEnabled ? YELLOW : BLACK);
  iconTransmissionWarningDisp.setValue(data->transmissionWarning && data->electricEnabled);
  #ifdef TM1638_D
  tmb.setLED(5, data->transmissionWarning && data->electricEnabled ? 1 : 0);
  #endif
  // drawIcon(mylcd, iconCruiseControl, 102, 130 - 24, (data->cspd > 0) ? GREEN : BLACK);
  iconCruiseControlDisp.setValue((data->cspd > 0));

  iconFuelWarningDisp.setValue(data->fuelWarning && data->electricEnabled);
  #ifdef TM1638_D
  tmb.setLED(6, data->fuelWarning && data->electricEnabled ? 1 : 0);
  #endif

  #ifdef TM1638_D
  if (data->electricEnabled)
  {
    char vals[4];
    const char *fmt;
    uint16_t dvals;
    memset(vals, 32, 4);
    switch (dispId)
    {
    case 0:
      fmt = PSTR("OIL");
      dvals = data->oilPressure;
      break;
    case 1:
      fmt = PSTR("AIR");
      dvals = data->airPressure;
      break;
    case 2:
      fmt = PSTR("T");
      dvals = data->waterTemp / 10;
      break;
    case 3:
      fmt = PSTR("V");
      dvals = data->accumVoltage;
      break;
    case 4:
      fmt = PSTR("BT");
      dvals = data->brakeTemp / 10;
      break;
    case 5:
      fmt = PSTR("OILT");
      dvals = data->oilTemp / 10;
      break;
    case 6:
      fmt = PSTR("FUEL");
      dvals = data->fuel;
      break;
    }
    strcpy_P(vals, fmt);
    //snprintf_P(vals, 9, fmt, dvals);
    for (byte kl=0; kl < 4; kl++) {
      tmb.displayASCII(kl, vals[kl]);
    }
    memset(vals, 32, 4);
    itoa(dvals, vals, DEC);
    for (byte kl=0; kl < 4; kl++) {
      tmb.displayASCII(kl+4, vals[kl]);
    }    
    tmbReseted = false;
  }
  else
  {
    if (!tmbReseted)
    {
      tmb.reset();
      tmbReseted = true;
    }
  }
  #endif

  mylcd.Set_Text_Mode(0);
  mylcd.Set_Text_colour(GREEN);
  mylcd.Set_Text_Back_colour(BLACK);
  mylcd.Set_Text_Size(1);
  mylcd.Print_Number_Int(data->gear, 96, 90, 4, ' ', 10);
  unsigned long tm2 = micros() - tm;
  static unsigned long alltm;
  if (alltm < tm2)
    alltm = tm2;
  mylcd.Print_Number_Int((alltm > 1000 ? alltm / 1000 : alltm), 96, 80, 5, ' ', 10);
#endif

#ifdef LCDI2C
  lcd.setCursor(13, 1);
  itoa(data->gear, tmp, 10);
  lcd.print(tmp);
#endif
}

void (*resetFunc)(void) = 0;

void reset()
{

  for (int i = 0; i <= 13; i++)
  {
    pinMode(i, OUTPUT);
    digitalWrite(i, LOW);
  }
  resetFunc();
}

void _RESET(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  reset();
}

void _ATGCAP(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  char *buf = (char *)malloc(strlen_P(ATGCAP) + 1);
  strcpy_P(buf, ATGCAP);
  printEcho(buf);
  Serial.println(F("CAN,J1939"));
  free(buf);
}

void _ATGMM(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  char *buf = (char *)malloc(strlen_P(ATGMM) + 1);
  strcpy_P(buf, ATGMM);
  printEcho(buf);
  Serial.println(F("DASHBOARD1.0"));
  free(buf);
}

void _ATEIGN(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATEIGN);
  bool quet = false;
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    data->electricEnabled = bufToInt(buffer, tmp + 1, 1, 0);
  }
  if (!quet)
  {
    char *buf = (char *)malloc(tmp + 1);
    strcpy_P(buf, ATEIGN);
    printEcho(buf);
    Serial.println(data->electricEnabled);
    free(buf);
  }
  displayData(&ets2Data);
}

#ifdef TFT130
void _ATEFLC(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATEFLC);
  bool quet = false;
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    fuelmeter.setMaxValue(bufToInt(buffer, tmp + 1, 4, 0));
  }
  if (!quet)
  {
    char *buf = (char *)malloc(tmp + 1);
    strcpy_P(buf, ATEFLC);
    printEcho(buf);
    Serial.println(fuelmeter.getMaxValue());
    free(buf);
  }
  displayData(&ets2Data);
}
#endif

void _ATESPD(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATESPD);
  bool quet = false;
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    data->spd = bufToInt(buffer, tmp + 1, 15, 0);
  }
  if (!quet)
  {
    char *buf = (char *)malloc(tmp + 1);
    strcpy_P(buf, ATESPD);
    printEcho(buf);
    Serial.print(data->spd);
    Serial.print(';');
    Serial.println((data->spd * 36) / 100);
    free(buf);
  }
  displayData(&ets2Data);
}

void _ATEE(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATEE);
  bool quet = false;
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    *echo = bufToInt(buffer, tmp + 1, 15, 0);
  }
  if (!quet)
  {
    char *buf = (char *)malloc(tmp + 1);
    strcpy_P(buf, ATEE);
    printEcho(buf);
    Serial.println(*echo);
    free(buf);
  }
}

void _ATELFT(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATELFT);
  bool quet = false;
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    data->leftBlinkerLight = bufToInt(buffer, tmp + 1, 1, 0);
  }
  if (!quet)
  {
    char *buf = (char *)malloc(tmp + 1);
    strcpy_P(buf, ATELFT);
    printEcho(buf);
    Serial.println(data->leftBlinkerLight);
    free(buf);
  }
  displayData(&ets2Data);
}

void _ATERAW(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATERAW);
  bool quet = false;
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    char b[4] = "0x";
    byte k = 0;
    byte i = tmp + 1;
    while (i < tmp + 1 + sizeof(ETS2Data) * 2)
    {
      b[2] = buffer[i];
      i++;
      b[3] = buffer[i];
      i++;
      data->buffer[k] = strtol(b, NULL, 16);
      k++;
    }
  }
  if (!quet)
  {
    char *buf = (char *)malloc(tmp + 1);
    strcpy_P(buf, ATERAW);
    printEcho(buf);
    free(buf);

    buf = (char *)malloc(sizeof(ETS2Data) * 2);
    char hex[3];
    for (byte i = 0; i < sizeof(ETS2Data); i++)
    {
      itoa(data->buffer[i], hex, HEX);
      if (data->buffer[i] <= 15)
      {
        hex[1] = hex[0];
        hex[0] = '0';
        hex[2] = 0;
      }
      strcat(buf, hex);
    }
    Serial.println(buf);
    free(buf);
  }
  displayData(&ets2Data);
}

void _ATCCLK(boolean *echo, const InputBuffer buffer, ETS2Data *data)
{
  byte tmp = strlen_P(ATCCLK);
  bool quet = false;
  char *buf = (char *)malloc(tmp + 1);
  tmp += 3;
  if (buffer[tmp] == '=')
  {
    quet = !*echo;
    gadgetTime = bufToInt(buffer, tmp + 1, 15, 0);
  }
  if (!quet)
  {
    strcpy_P(buf, ATCCLK);
    printEcho(buf);
    Serial.println(gadgetTime);
    free(buf);
  }
}

const FuncHandler handlers[] = {
    {ATCCLK, _ATCCLK},
    {ATRESET, _RESET},
    {ATGCAP, _ATGCAP},
    {ATGMM, _ATGMM},
    {ATESPD, _ATESPD},
    {ATERAW, _ATERAW},
    {ATEIGN, _ATEIGN},
    {ATELFT, _ATELFT},
#ifdef TFT130    
    {ATEFLC, _ATEFLC},
#endif    
    {ATEE, _ATEE}};

int DoHandleCommand(InputBuffer buffer)
{
  for (byte i = 0; i < sizeof(handlers) / sizeof(FuncHandler); i++)
  {
    if (!memcmp_P(&buffer[3], handlers[i].cmd, strlen_P(handlers[i].cmd)))
    {
      handlers[i].func(&echo, buffer, &ets2Data);
      return 1;
    }
  }
  return 0;
}

void setup()
{
// put your setup code here, to run once:
#ifndef TFT130
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
#endif

#ifdef ATMEGA32U4
  Keyboard.begin();
#endif

  Serial.begin(115200);
  Serial.println("AT command test handler");
  #ifdef TM1638_D
  tmb.displayBegin();
  #endif
  bufferReady = false;
  memset(ets2Data.buffer, 0, sizeof(ets2Data));
  gadgetTime = millis();

#ifdef LCDI2C
  lcd.init();
  lcd.backlight();
  lcd.print(F("ETS2 CAN 1.0a"));
#endif

#ifdef TFT130
  mylcd.init();
  mylcd.Fill_Screen(BLACK);
  initDisplay();
#endif
}

void serialEvent()
{
  while (Serial.available())
  {
    unsigned char b = Serial.read();

    if (((b != 'A') && (pos == 0)) || ((b != 'T') && (pos == 1)))
    {
      pos = 0;
      break;
    }

    inputBuffer[pos] = b;
    pos++;

    if ((b == 0x0d) || (b == 0x0a) || (pos >= BUFFER_SIZE))
    {
      if ((b == 0x0d) || (b == 0x0a))
      {
        len = pos - 1;
      }
      else
      {
        len = pos;
      }
      pos = 0;
      bufferReady = true;
      break;
    }
  }
}

uint8_t oldBtn;

void loop()
{
  #ifdef TM1638_D
  uint8_t btn = tmb.readButtons();
  if (btn != oldBtn)
  {
    delay(10);
    btn = tmb.readButtons();
    if (btn & 0x80)
    {
      dispId++;
      if (dispId > 6)
        dispId = 0;
      displayData(&ets2Data);
    }
    #ifdef ATMEGA32U4

    if (btn & 0x01) {
      Keyboard.write('[');
    }
    if (btn & 0x02) {
      Keyboard.write(']');
    }
    if (btn & 0x04) {
      Keyboard.write('q');
    }
    if (btn & 0x08) {
      Keyboard.write('e');
    }
    #endif
    oldBtn = btn;
  }
  #endif

  // put your main code here, to run repeatedly:
  #ifdef TFT130
  mylcd.fillRect(0, 0, 2, 2, RED);
  #endif

  serialEvent();
  gadgetTime = gadgetTime + millis() - oldTime;
  oldTime = millis();
  if (bufferReady)
  {
    #ifdef TFT130
    mylcd.fillRect(0, 0, 2, 2, GREEN);
    #endif
#ifdef DEBUG
    Serial.print(F(".command length:"));
    Serial.println(len);
#endif
    if ((inputBuffer[0] == 'A') && (inputBuffer[1] == 'T'))
    {
      if (len >= 3)
      {
        if (inputBuffer[2] == '+')
        {
          if (DoHandleCommand(inputBuffer))
          {
            Serial.println(F("OK"));
          }
        }
      }
      else
      {
        Serial.println(F("OK"));
      }
    }
    memset(inputBuffer, 0, BUFFER_SIZE);
    bufferReady = false;
  }
}
