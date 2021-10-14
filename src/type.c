#include "type.h"

int TypePrintf(Type symbolTableType)
{
    switch (symbolTableType)
    {
    case INT:
        return printf("Int");

    case FLOAT:
        return printf("Float");

    case CHAR:
        return printf("Char");

    case BOOL:
        return printf("Bool");

    default:
        return 1;
    }
}
