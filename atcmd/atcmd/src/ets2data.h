#ifndef ETS_DATA_STRUCT
#define ETS_DATA_STRUCT
#include <Arduino.h>

typedef union 
{
  byte buffer[18];
  struct {
    word spd: 10;
    word cspd: 10;
    word rpm: 14;
    word fuel: 11;
    byte airPressure: 8;
    byte wear: 7;
    byte oilPressure: 7;
    word accumVoltage: 9;
    word waterTemp: 11;
    word brakeTemp:12;
    byte gear: 5;
    byte retarder: 3;
    byte leftBlinker: 1;
    byte rightBlinker: 1;
    byte leftBlinkerLight: 1;
    byte rightBlinkerLight: 1;
    byte lightParking: 1;
    byte lightLowBeam: 1;
    byte lightHighBeam: 1;
    byte electricEnabled: 1;
    byte parkingBracke: 1;
    byte motorBrake: 1;
    byte airPressureWarning: 1;
    byte airPressureEmergency: 1;
    byte fuelWarning: 1;
    byte adblueWarning: 1;
    byte oilPressureWarning: 1;
    byte waterTempWaring: 1;
    byte wheelWarning: 1;
    byte engineEnabled: 1;
    byte lightAuxFront: 1;
    byte lightAuxRoof: 1;
    byte lightBeacom: 1;
    byte lightBrake: 1;
    byte lightReverse: 1;
    byte checkEngine: 1;
    byte batteryVoltageWarning: 1;
    byte transmissionWarning: 1;
    word oilTemp: 11;
  };
} ETS2Data;

/*
typedef union
{
  byte buffer[21];
  struct
  {
    word spd;  // m/s * 10
    word cspd; // m/s * 10
    word rpm;
    word fuel;
    byte airPressure;
    byte wear;
    byte oilPressure;
    byte gear : 5;
    byte retarder : 3;
    union
    {
      byte flag1;
      struct
      {
        byte leftBlinker : 1,
            rightBlinker : 1,
            leftBlinkerLight : 1,
            rightBlinkerLight : 1,
            lightParking : 1,
            lightLowBeam : 1,
            lightHighBeam : 1,
            electricEnabled : 1;
      };
    };
    union
    {
      byte flag2;
      struct
      {
        byte parkingBracke : 1,
            motorBrake : 1,
            airPressureWarning : 1,
            airPressureEmergency : 1,
            fuelWarning : 1,
            adblueWarning : 1,
            oilPressureWarning : 1,
            waterTempWaring : 1;
      };
    };
    union
    {
      byte flag3;
      struct
      {
        byte wheelWarning : 1,
            engineEnabled : 1,
            lightAuxFront : 1,
            lightAuxRoof : 1,
            lightBeacom : 1,
            lightBrake : 1,
            lightReverse : 1,
            checkEngine : 1;
      };
    };
    word accumVoltage : 12;
    word batteryVoltageWarning : 1;
    word transmissionWarning : 1;
    word reserved2 : 1;
    word reserved3 : 1;
    word waterTemp;
    word brakeTemp;
  };

} ETS2Data;
*/
#endif