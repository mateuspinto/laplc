#include "type.h"

int TypePrintf(Type symbolTableType)
{
    switch (symbolTableType)
    {
    case INT:
        printf("Int");
        break;

    case FLOAT:
        printf("Float");
        break;

    case CHAR:
        printf("Char");
        break;

    case BOOL:
        printf("Bool");
        break;

    default:
        break;
    }
}
