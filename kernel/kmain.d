//###################################################
// File: kmain.d
// Created: 2015-10-29 15:34:16
// Modified: 2015-10-29 15:34:17
//
// See LICENSE file for license and copyright details
//###################################################


module kernel.kmain;

//import kernel.drt0;

immutable uint COLUMNS = 80; // 80-col screen
immutable uint LINES = 24; // 24-line screen
immutable auto VIDMEM_BASE = 0xFFFF8000000B8000;
// So we compile without druntime
extern(C) __gshared void* _d_dso_registry;
extern(C) __gshared void* _Dmodule_ref;
extern(C) __gshared void* _d_arraybounds;
extern(C) __gshared void* _d_assert;
extern(C) __gshared void* _d_unittest;



static immutable ubyte egaBlack = 0;
static immutable ubyte egaBlue = 1;
static immutable ubyte egaGreen = 2;
static immutable ubyte egaCyan = 3;
static immutable ubyte egaRed = 4;
static immutable ubyte egaMagnenta = 5;
static immutable ubyte egaBrown = 6;
static immutable ubyte egaGrey2 = 7;
static immutable ubyte egaGrey = 8;
static immutable ubyte egaBlue2 = 9;
static immutable ubyte egaGreen2 = 0xa;
static immutable ubyte egaCyan2 = 0xb;
static immutable ubyte egaRed2 = 0xc;
static immutable ubyte egaMagenta2 = 0xd;
static immutable ubyte egaYellow2 = 0xe;
static immutable ubyte egaWhite= 0xf;

ushort videoValue(ubyte value, ubyte fg = egaWhite, ubyte bg = egaBlack)
{
    return cast(ushort)( ( ((bg <<4) | fg) << 8) | (value & 0xFF) );
}

 void kprintf(string str, int xpos, int ypos)
{    
    auto idx = (xpos + ypos * COLUMNS);
    ushort* vidmem = cast(ushort*)VIDMEM_BASE + (xpos + ypos * COLUMNS);
    int x = xpos;
    for(int i = 0; i < str.length; ++i) {
        char s=  str[i];
        *(vidmem+x) = videoValue(s, egaYellow2, egaGrey);
        ++x;
    }
}
void clearScreen(ubyte col = egaGrey)    
{
    fillScreen(0, 0, col);
}
void fillScreen(ubyte value, ubyte fgCol, ubyte bgCol)
{
    ushort* vidmem = cast(ushort*)VIDMEM_BASE;
    // Clear the screen
    foreach(i; 0..COLUMNS*LINES*2) {
        *(vidmem+i) = videoValue(value, fgCol, bgCol);
    }
}
extern (C) void kmain() {
    int ypos = 0;
    int xpos = 0;

    clearScreen(egaGrey);

    auto message = `Lyrebird OS -- Kernel r0 [`~__DATE__~`-`~__TIME__~`]`;
    kprintf(message, 1, 1);
    for(;;) {} // Loop forever
}
