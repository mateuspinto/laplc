#ifndef SEMANTIC_VALUE_H
#define SEMANTIC_VALUE_H

#include "constants.h"
#include "type.h"

typedef struct
{
    char String[MAX_IDENTIFIER_SIZE];
    Type type;

} SemanticValue;

#endif
