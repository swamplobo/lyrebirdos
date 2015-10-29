//###################################################
// File: drt0.d
// Created: 2015-10-29 15:34:04
// Modified: 2015-10-29 15:34:09
//
// See LICENSE file for license and copyright details
//###################################################

module kernel.drt0;

size_t kstrlen(immutable char* str)
{
    immutable(char)* s = str;
    size_t ret = 0;
    while(s) {++ret; ++s;}
    return ret;
}

