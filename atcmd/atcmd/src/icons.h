#ifndef ETS_ICONS
#define ETS_ICONS
#include <Arduino.h>
#include <LCDWIKI_GUI.h>
#include <SSD1283A.h>
#include "colors.h"

static const uint16_t iconLightLowBeam[] PROGMEM = {
    0x00e0, //0000000011100000,
    0x0138, //0000000100111000,
    0xF002, //0001110100000100,
    0xF102, //1111000100000010,
    0x1D03, //0001110100000011,
    0xF101, //1111000100000001,
    0x1D03, //0001110100000011,
    0xF102, //1111000100000010,
    0x1D04, //0001110100000100,
    0xF138, //1111000100111000,
    0x00E0  //0000000011100000
};

static const uint16_t iconLightHighBeam[] PROGMEM = {
    0x0070, //0000000001110000,
    0x009C, //0000000010011100,
    0x7D06, //0111110100000110,
    0x0102, //0000000100000010,
    0x7D01, //0111110100000001,
    0x0101, //0000000100000001,
    0x7D01, //0111110100000001,
    0x0101, //0000000100000010,
    0x7D01, //0111110100000110,
    0x019C, //0000000110011100,
    0x0070  //0000000001110000
};

static const uint16_t iconHandbrake[] PROGMEM = {
    0x27E4, //0010011111100100,
    0x4812, //0100100000010010,
    0x538A, //0101001110001010,
    0xD248, //1101001001001011,
    0xE247, //1110001001000111,
    0xE247, //1110001001000111,
    0xE387, //1110001110000111,
    0xD20B, //1101001000001011,
    0x520A, //0101001000001010,
    0x4812, //0100100000010010,
    0x27E4  //0010011111100100
};

static const uint16_t iconBrakeWarn[] PROGMEM = {
    0x27E4, //0010011111100100,
    0x4812, //0100100000010010,
    0x518A, //0101000110001010,
    0xD18B, //1101000110001011,
    0xE187, //1110000110000111,
    0xE187, //1110000110000111,
    0xE187, //1110000110000111,
    0xD00B, //1101000000001011,
    0x518A, //0101000110001010,
    0x4812, //0100100000010010,
    0x27E4  //0010011111100100
};

static const uint16_t iconCheckEngine[] PROGMEM = {
    0x0780, //0000011110000000,
    0x0FF0, //0000111111110000,
    0xB838, //1011100000111000,
    0xA00F, //1010000000001111,
    0xA7C1, //1010011111000001,
    0xE001, //1110000000000001,
    0xE001, //1110000000000001,
    0xAEF9, //1010111011111001,
    0xA001, //1010000000000001,
    0x380F, //0011100000001111,
    0x0FF8  //0000111111111000
};

static const uint16_t iconParkingLight[] PROGMEM = {
    0x0000, //0000000000000000,
    0x6003, //0110000000000011,
    0x3636, //0011011000110110,
    0x1D5C, //0001110101011100,
    0x0550, //0000010101010000,
    0x7D5F, //0111110101011111,
    0x0550, //0000010101010000,
    0x1D5C, //0001110101011100,
    0x3636, //0011011000110110,
    0x6003, //0110000000000011,
    0x0000  //0000000000000000
};
static const uint16_t iconLeftTurn[] PROGMEM = {
    0x0100, //000000100000000
    0x0300, //000001100000000
    0x0700, //000011100000000
    0x0FFF, //000111111111111
    0x1FFF, //001111111111111
    0x3FFF, //011111111111111
    0x1FFF, //001111111111111
    0x0FFF, //000111111111111
    0x0700, //000011100000000
    0x0300, //000001100000000
    0x0100  //000000100000000
};

static const uint16_t iconOilWarning[] PROGMEM = {
    0x0000, //0000000000000000
    0x0000, //0000000000000000
    0xC700, //1100011100000000
    0xA206, //1010001000000110
    0x7F08, //0111111100001000
    0x20F3, //0010000011110011
    0x2023, //0010000000100011
    0x2040, //0010000001000000
    0x3F80, //0011111110000000
    0x0000, //0000000000000000
    0x0000  //0000000000000000
};

static const uint16_t iconWaterWarning[] PROGMEM = {
    0x0300, //0000001100000000
    0x03E0, //0000001111100000
    0x0300, //0000001100000000
    0x03E0, //0000001111100000
    0x0300, //0000001100000000
    0x03E0, //0000001111100000
    0x0300, //0000001100000000
    0xFFFF, //1111111111111111
    0x1998, //0001100110011000
    0x6666, //0110011001100110
    0x1998  //0001100110011000
};

static const uint16_t iconAccumWarning[] PROGMEM = {
    0x1C38, //0001110000111000
    0x7FFE, //0111111111111110
    0x4002, //0100000000000010
    0x4012, //0100000000010010
    0x5C3A, //0101110000111010
    0x4012, //0100000000010010
    0x4002, //0100000000000010
    0x4002, //0100000000000010
    0x4002, //0100000000000010
    0x7FFE, //0111111111111110
    0x0000  //0000000000000000
};

static const uint16_t iconWheelWarning[] PROGMEM = {
    0x1998, //0001100110011000
    0x1998, //0001100110011000
    0x1998, //0001100110011000
    0x318C, //0011000110001100
    0x6186, //0110000110000110
    0x6006, //0110000000000110
    0x6186, //0110000110000110
    0x6186, //0110000110000110
    0x300C, //0011000000001100
    0x1FF8, //0001111111111000
    0x1998  //0001100110011000
};

static const uint16_t iconTransmissionWarning[] PROGMEM = {
    0x05A0, //0000010110100000
    0x13C8, //0001001111001000
    0x0C30, //0000110000110000
    0x2994, //0010100110010100
    0x1188, //0001000110001000
    0x318C, //0011000110001100
    0x1008, //0001000000001000
    0x2994, //0010100110010100
    0x0C30, //0000110000110000
    0x13C8, //0001001111001000
    0x05A0  //0000010110100000
};

static const uint16_t iconCruiseControl[] PROGMEM = {
    0x2800, //0010100000000000
    0x19C0, //0001100111000000
    0x3E30, //0011111000110000
    0x0C10, //0000110000010000
    0x0A08, //0000101000001000
    0x1188, //0001000110001000
    0x1188, //0001000110001000
    0x1008, //0001000000001000
    0x0810, //0000100000010000
    0x0C30, //0000110000110000
    0x03C0  //0000001111000000
};

static const uint16_t iconFuelWarning[] PROGMEM = {
    0x0000, //0000000000000000
    0x0F90, //0000111110010000
    0x18D8, //0001100011011000
    0x18C8, //0001100011001000
    0x1FC8, //0001111111001000
    0x1FEC, //0001111111101100
    0x18E4, //0001100011100100
    0x18E4, //0001100011100100
    0x18FC, //0001100011111100
    0x18D8, //0001100011011000
    0x1FC0  //0001111111000000
};

class Icon
{
protected:
    const uint16_t *icon;
    uint8_t x, y;
    uint16_t color;
    boolean value;
    SSD1283A_GUI *display;
    virtual void draw(uint16_t color);

public:
    Icon(SSD1283A_GUI *display, const uint16_t *icon, uint8_t x, uint8_t y, uint16_t color);
    void setValue(boolean value);
};

class IconBack : public Icon
{
protected:
    void draw(uint16_t color);

public:
    IconBack(SSD1283A_GUI *display, const uint16_t *icon, uint8_t x, uint8_t y, uint16_t color);
};

#endif