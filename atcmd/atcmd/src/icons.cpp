#include "icons.h"
#include <Arduino.h>
#include <LCDWIKI_GUI.h>
#include <SSD1283A.h>
#include "colors.h"

Icon::Icon(SSD1283A_GUI *display, const uint16_t *icon, uint8_t x, uint8_t y, uint16_t color)
{
    this->display = display;
    this->icon = icon;
    this->x = x;
    this->y = y;
    this->color = color;
}

void Icon::draw(uint16_t color)
{
    uint8_t dx = 0;
    uint8_t dy = 0;
    for (byte k = 0; k <= 10; k++)
    {
        uint16_t e = pgm_read_word(this->icon + k);
        for (byte b = 16; b > 0; b--)
        {
            if (e & (1 << (b - 1)))
                this->display->drawPixel(this->x + dx, this->y + dy, color);
            dx++;
        }
        if (dx > 15)
            dx = 0;
        dy++;
    }
}

void Icon::setValue(boolean value) {
    if (this->value != value) {
        this->value = value;
        if (this->value) {
            draw(this->color);
        } else {
            draw(BLACK);
        }
    }
}

IconBack::IconBack(SSD1283A_GUI *display, const uint16_t *icon, uint8_t x, uint8_t y, uint16_t color):Icon(display, icon, x, y, color){};

void IconBack::draw(uint16_t color) {
    uint8_t dx = 0;
    uint8_t dy = 0;
    for (byte k = 0; k <= 10; k++)
    {
        uint16_t e = pgm_read_word(this->icon + k);
        for (byte b = 0; b <= 15; b++)
        {
            if (e & (1 << (b - 1)))
                this->display->drawPixel(this->x + dx, this->y + dy, color);
            dx++;
        }
        if (dx > 15)
            dx = 0;
        dy++;
    }
}