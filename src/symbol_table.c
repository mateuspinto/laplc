#include "symbol_table.h"

int SymbolTableDefinitionPrintf(SymbolTableDefinition symbolTableDefinition)
{
    switch (symbolTableDefinition)
    {
    case STD_LET:
        return printf("Let");

    case STD_CONST:
        return printf("Const");

    case STD_FUNCTION:
        return printf("Function");

    default:
        return 1;
    }
}

int SymbolTableEntryInitialize(SymbolTableEntry *symbolTableEntry)
{
    strcpy(symbolTableEntry->identifier, "");

    symbolTableEntry->definiton = STD_UNDEFINED;
    symbolTableEntry->returnType = UNDEFINED;
    symbolTableEntry->argumentNumber = 0;

    for (size_t i = 0; i < MAX_ARGUMENT_NUMBER; i++)
    {
        symbolTableEntry->argumentTypes[i] = UNDEFINED;
    }

    return 0;
}

int SymbolTableEntrySetLet(SymbolTableEntry *symbolTableEntry, char *identifier, Type type)
{
    strcpy(symbolTableEntry->identifier, identifier);

    symbolTableEntry->returnType = type;
    symbolTableEntry->argumentNumber = 0;
    symbolTableEntry->definiton = STD_LET;

    return 0;
}

int SymbolTableEntrySetConst(SymbolTableEntry *symbolTableEntry, char *identifier, Type type)
{
    strcpy(symbolTableEntry->identifier, identifier);

    symbolTableEntry->returnType = type;
    symbolTableEntry->argumentNumber = 0;
    symbolTableEntry->definiton = STD_CONST;

    return 0;
}

int SymbolTableEntryAddFunctionArgumentType(SymbolTableEntry *symbolTableEntry, Type argumentType)
{
    symbolTableEntry->argumentTypes[symbolTableEntry->argumentNumber] = argumentType;
    symbolTableEntry->argumentNumber++;

    return 0;
}

int SymbolTableEntryFinishAddFunction(SymbolTableEntry *symbolTableEntry, char *identifier, Type returnType)
{
    strcpy(symbolTableEntry->identifier, identifier);
    symbolTableEntry->returnType = returnType;
    symbolTableEntry->definiton = STD_FUNCTION;

    return 0;
}

int SymbolTableEntryPrintf(SymbolTableEntry *symbolTableEntry)
{
    printf("%s - ", symbolTableEntry->identifier);
    SymbolTableDefinitionPrintf(symbolTableEntry->definiton);
    printf(" - ");
    TypePrintf(symbolTableEntry->returnType);

    printf(" - [");
    for (size_t i = 0; i < symbolTableEntry->argumentNumber; i++)
    {
        TypePrintf(symbolTableEntry->argumentTypes[i]);

        if (i != symbolTableEntry->argumentNumber - 1)
            printf(", ");
    }
    printf("]");

    printf("\n");
    return 0;
}

int SymbolTableInitialize(SymbolTable *symbolTable)
{
    for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
    {
        SymbolTableEntryInitialize(&(symbolTable->table[i]));
    }

    symbolTable->next_empty_slot = 0;
    return 0;
}

int SymbolTableAddLet(SymbolTable *symbolTable, char *identifier, Type type)
{
    if (symbolTable->next_empty_slot == SYMBOL_TABLE_SIZE)
    {
        printf("laplc: symbol table full");
        exit(1);
    }

    SymbolTableEntrySetLet(symbolTable->table + symbolTable->next_empty_slot, identifier, type);
    symbolTable->next_empty_slot++;

    return 0;
}

int SymbolTableAddConst(SymbolTable *symbolTable, char *identifier, Type type)
{
    if (symbolTable->next_empty_slot == SYMBOL_TABLE_SIZE)
    {
        printf("laplc: memory error, symbol table full");
        exit(1);
    }

    SymbolTableEntrySetConst(symbolTable->table + symbolTable->next_empty_slot, identifier, type);
    symbolTable->next_empty_slot++;

    return 0;
}

int SymbolTableAddFunctionArgumentType(SymbolTable *symbolTable, Type argumentType)
{
    return SymbolTableEntryAddFunctionArgumentType(symbolTable->table + symbolTable->next_empty_slot, argumentType);
}

int SymbolTableFinishAddFunction(SymbolTable *symbolTable, char *identifier, Type returnType)
{
    if (symbolTable->next_empty_slot == SYMBOL_TABLE_SIZE)
    {
        printf("laplc: memory error, symbol table full");
        exit(1);
    }

    SymbolTableEntryFinishAddFunction(symbolTable->table + symbolTable->next_empty_slot, identifier, returnType);
    symbolTable->next_empty_slot++;

    return 0;
}

Type SymbolTableGetVariableOrConstType(SymbolTable *symbolTable, char *identifier)
{
    for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
    {
        if ((strcmp((symbolTable->table + i)->identifier, identifier) == 0 ? 1 : 0) && (((symbolTable->table + i)->definiton == STD_LET) || ((symbolTable->table + i)->definiton == STD_CONST)))
        {
            return (symbolTable->table + i)->returnType;
        }
    }

    return UNDEFINED;
}

Type SymbolTableGetFunctionReturnType(SymbolTable *symbolTable, char *identifier)
{
    for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
    {
        if ((strcmp((symbolTable->table + i)->identifier, identifier) == 0 ? 1 : 0) && ((symbolTable->table + i)->definiton == STD_FUNCTION))
        {
            return (symbolTable->table + i)->returnType;
        }
    }

    return UNDEFINED;
}

int SymbolTableTestFunctionArgumentTypes(SymbolTable *symbolTable, char *identifier, Type *argumentTypes, int argumentNumber)
{ // (-1) Okay, (-2) Number of arguments incorrect, (-3) Function does not exist, (N) Type error of argument N

    for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
    {
        if ((strcmp((symbolTable->table + i)->identifier, identifier) == 0 ? 1 : 0) && ((symbolTable->table + i)->definiton == STD_FUNCTION))
        {
            if ((symbolTable->table)->argumentNumber != argumentNumber)
                return -2;

            for (size_t j = 0; j < argumentNumber; j++)
            {
                if ((symbolTable->table + i)->argumentTypes[j] != argumentTypes[j])
                    return j;
            }

            return -1;
        }
    }

    return -3;
}

int SymbolTablePrintf(SymbolTable *symbolTable)
{
    printf("<Identifier>, <Definition>, <ReturnType>, [<ArgumentTypes>*]\n");
    for (size_t i = 0; i < symbolTable->next_empty_slot; i++)
    {
        SymbolTableEntryPrintf(&(symbolTable->table[i]));
    }

    return 0;
}
