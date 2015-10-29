//############################################
// Copyright (C) Lyrebird Software 1996-2014
// File: drt0.d
// Created: 2014-05-07 19:49:42
// Modified: 2014-05-07 20:25:37
//############################################

module kernel.drt0;



size_t kstrlen(immutable char* str)
{
    immutable(char)* s = str;
    size_t ret = 0;
    while(s) {++ret; ++s;}
    return ret;
}

