#ifndef TYPE_H
#define TYPE_H

#include <stdio.h>

typedef enum
{
    UNDEFINED,
    INT,
    FLOAT,
    CHAR,
    BOOL,
    STRING
} Type;

int TypePrintf(Type symbolTableType);

#endif
