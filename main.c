#include <stdio.h>
#include "src/symbol_table.h"

int main(void)
{
    SymbolTable tabelinha;

    Type tipos[MAX_ARGUMENT_NUMBER];
    int numeroArgumentos = 2;

    for (size_t i = 0; i < MAX_ARGUMENT_NUMBER; i++)
    {
        tipos[i] = UNDEFINED;
    }

    tipos[0] = INT;
    tipos[1] = INT;

    SymbolTableInitialize(&tabelinha);

    SymbolTableAddFunctionArgumentType(&tabelinha, INT);
    SymbolTableAddFunctionArgumentType(&tabelinha, INT);

    SymbolTableFinishAddFunction(&tabelinha, "soma", INT);

    printf("%d\n", SymbolTableTestFunctionArgumentTypes(&tabelinha, "soma", tipos, numeroArgumentos));

    return 0;
}
