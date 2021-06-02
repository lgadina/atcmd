
#ifndef ETS_COMMANDS
#define ETS_COMMANDS

#include <Arduino.h>
#include <ets2data.h>

#define BUFFER_SIZE 255

const char ATCCLK[] PROGMEM = "CCLK";
const char ATRESET[] PROGMEM = "RESET";
const char ATSET[] PROGMEM = "SET";
const char ATEE[] PROGMEM = "EE";
const char ATGCAP[] PROGMEM = "GCAP";
const char ATGMM[] PROGMEM = "GMM";
const char ATESPD[] PROGMEM = "ESPD";
const char ATERPM[] PROGMEM = "ERPM";
const char ATECRS[] PROGMEM = "ECRS";
const char ATEFUEL[] PROGMEM = "EFUEL";
const char ATEFLG1[] PROGMEM = "EFLG1";
const char ATEFLG2[] PROGMEM = "EFLG2";
const char ATEFLG3[] PROGMEM = "EFLG3";
const char ATERAW[] PROGMEM = "ERAW";
const char ATEIGN[] PROGMEM = "EIGN";
const char ATELFT[] PROGMEM = "ELFT";
const char ATEFLC[] PROGMEM = "EFLC"; // set fuel capacity

typedef unsigned char InputBuffer[BUFFER_SIZE];
typedef void (*CMDHandler)(boolean* echo, const InputBuffer buffer, ETS2Data* data);

typedef struct
{
  PGM_P cmd;
  CMDHandler func;
} FuncHandler;


int bufToInt(const InputBuffer buffer, byte startPos, byte maxLen, char val);
void printEcho(const char *buf);

#endif