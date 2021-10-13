#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SYMBOL_TABLE_SIZE 1024
#define IDENTIFIER_ALLOC_SIZE 64
#define MAX_ARGUMENT_NUMBER 32

typedef enum
{
  STD_UNDEFINED,
  STD_LET,
  STD_FUNCTION,
  STD_CONST
} SymbolTableDefinition;

int SymbolTableDefinitionPrintf(SymbolTableDefinition symbolTableDefinition)
{
  switch (symbolTableDefinition)
  {
  case STD_LET:
    printf("Let");
    break;

  case STD_CONST:
    printf("Const");
    break;

  case STD_FUNCTION:
    printf("Function");
    break;

  default:
    break;
  }
}

typedef enum
{
  STT_UNDEFINED,
  STT_INT,
  STT_FLOAT,
  STT_CHAR,
  STT_BOOL
} SymbolTableType;

int SymbolTableTypePrintf(SymbolTableType symbolTableType)
{
  switch (symbolTableType)
  {
  case STT_INT:
    printf("Int");
    break;

  case STT_FLOAT:
    printf("Flot");
    break;

  case STT_CHAR:
    printf("Char");
    break;

  case STT_BOOL:
    printf("Bool");
    break;

  default:
    break;
  }
}

typedef struct
{
  char identifier[IDENTIFIER_ALLOC_SIZE];

  SymbolTableDefinition definiton;
  SymbolTableType returnType;
  SymbolTableType argumentTypes[MAX_ARGUMENT_NUMBER];

  int argumentNumber;

} SymbolTableEntry;

int SymbolTableEntryInitialize(SymbolTableEntry *symbolTableEntry)
{
  strcpy(symbolTableEntry->identifier, "");

  symbolTableEntry->definiton = STD_UNDEFINED;
  symbolTableEntry->returnType = STT_UNDEFINED;
  symbolTableEntry->argumentNumber = 0;

  for (size_t i = 0; i < MAX_ARGUMENT_NUMBER; i++)
  {
    symbolTableEntry->argumentTypes[i] = STT_UNDEFINED;
  }

  return 0;
}

int SymbolTableEntrySetLet(SymbolTableEntry *symbolTableEntry, char *identifier, SymbolTableType type)
{
  strcpy(symbolTableEntry->identifier, identifier);

  symbolTableEntry->returnType = type;
  symbolTableEntry->argumentNumber = 0;
  symbolTableEntry->definiton = STD_LET;

  return 0;
}

int SymbolTableEntrySetConst(SymbolTableEntry *symbolTableEntry, char *identifier, SymbolTableType type)
{
  strcpy(symbolTableEntry->identifier, identifier);

  symbolTableEntry->returnType = type;
  symbolTableEntry->argumentNumber = 0;
  symbolTableEntry->definiton = STD_CONST;

  return 0;
}

int SymbolTableEntrySetFunction(SymbolTableEntry *symbolTableEntry, char *identifier, SymbolTableType returnType, SymbolTableType *argumentTypes)
{
  int argumentNumber = 0;

  strcpy(symbolTableEntry->identifier, identifier);

  symbolTableEntry->returnType = returnType;
  symbolTableEntry->definiton = STD_FUNCTION;

  for (size_t i = 0; i < MAX_ARGUMENT_NUMBER; i++)
  {
    if (argumentTypes[i] != STT_UNDEFINED)
      argumentNumber++;

    symbolTableEntry->argumentTypes[i] = argumentTypes[i];
  }

  symbolTableEntry->argumentNumber = argumentNumber;

  return 0;
}

int SymbolTableEntryPrintf(SymbolTableEntry *symbolTableEntry)
{
  printf("%s - ", symbolTableEntry->identifier);
  SymbolTableDefinitionPrintf(symbolTableEntry->definiton);
  printf(" - ");
  SymbolTableTypePrintf(symbolTableEntry->returnType);

  printf(" - [");
  for (size_t i = 0; i < symbolTableEntry->argumentNumber; i++)
  {
    SymbolTableTypePrintf(symbolTableEntry->argumentTypes[i]);

    if (i != symbolTableEntry->argumentNumber - 1)
      printf(", ");
  }
  printf("]");

  printf("\n");
  return 0;
}

typedef struct
{
  SymbolTableEntry table[SYMBOL_TABLE_SIZE];

  size_t next_empty_slot;
} SymbolTable;

int SymbolTableInitialize(SymbolTable *symbolTable)
{
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
  {
    SymbolTableEntryInitialize(&(symbolTable->table[i]));
  }

  symbolTable->next_empty_slot = 0;
  return 0;
}

int SymbolTableAddLet(SymbolTable *symbolTable, char *identifier, SymbolTableType type)
{
  if (symbolTable->next_empty_slot == SYMBOL_TABLE_SIZE)
  {
    printf("laplc: symbol table full");
    exit(1);
  }

  SymbolTableEntrySetLet(symbolTable->table + symbolTable->next_empty_slot, identifier, type);
  symbolTable->next_empty_slot++;
}

int SymbolTableAddConst(SymbolTable *symbolTable, char *identifier, SymbolTableType type)
{
  if (symbolTable->next_empty_slot == SYMBOL_TABLE_SIZE)
  {
    printf("laplc: memory error, symbol table full");
    exit(1);
  }

  SymbolTableEntrySetConst(symbolTable->table + symbolTable->next_empty_slot, identifier, type);
  symbolTable->next_empty_slot++;
}

int SymbolTableAddFunction(SymbolTable *symbolTable, char *identifier, SymbolTableType returnType, SymbolTableType *argumentTypes)
{
  if (symbolTable->next_empty_slot == SYMBOL_TABLE_SIZE)
  {
    printf("laplc: memory error, symbol table full");
    exit(1);
  }

  SymbolTableEntrySetFunction(symbolTable->table + symbolTable->next_empty_slot, identifier, returnType, argumentTypes);
  symbolTable->next_empty_slot++;
}

SymbolTableType SymbolTableGetVariableOrConstType(SymbolTable *symbolTable, char *identifier)
{
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
  {
    if ((strcmp((symbolTable->table + i)->identifier, identifier) == 0 ? 1 : 0) && (((symbolTable->table + i)->definiton == STD_LET) || ((symbolTable->table + i)->definiton == STD_CONST)))
    {
      return (symbolTable->table + i)->returnType;
    }
  }

  return STT_UNDEFINED;
}

SymbolTableType SymbolTableGetFunctionType(SymbolTable *symbolTable, char *identifier)
{
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
  {
    if ((strcmp((symbolTable->table + i)->identifier, identifier) == 0 ? 1 : 0) && ((symbolTable->table + i)->definiton == STD_FUNCTION))
    {
      return (symbolTable->table + i)->returnType;
    }
  }

  return STT_UNDEFINED;
}

int SymbolTablePrintf(SymbolTable *symbolTable)
{
  printf("Symbol Table: <Identifier>, <Definition>, <ReturnType>, [<ArgumentTypes>*]\n");
  for (size_t i = 0; i < symbolTable->next_empty_slot; i++)
  {
    SymbolTableEntryPrintf(&(symbolTable->table[i]));
  }
  return 0;
}

#endif
