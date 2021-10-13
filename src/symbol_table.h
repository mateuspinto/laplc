#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "type.h"

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

int SymbolTableDefinitionPrintf(SymbolTableDefinition symbolTableDefinition);

typedef struct
{
  char identifier[IDENTIFIER_ALLOC_SIZE];

  SymbolTableDefinition definiton;
  Type returnType;
  Type argumentTypes[MAX_ARGUMENT_NUMBER];

  int argumentNumber;

} SymbolTableEntry;

int SymbolTableEntryInitialize(SymbolTableEntry *symbolTableEntry);
int SymbolTableEntrySetLet(SymbolTableEntry *symbolTableEntry, char *identifier, Type type);
int SymbolTableEntrySetConst(SymbolTableEntry *symbolTableEntry, char *identifier, Type type);
int SymbolTableEntrySetFunction(SymbolTableEntry *symbolTableEntry, char *identifier, Type returnType, Type *argumentTypes);
int SymbolTableEntryPrintf(SymbolTableEntry *symbolTableEntry);

typedef struct
{
  SymbolTableEntry table[SYMBOL_TABLE_SIZE];

  size_t next_empty_slot;
} SymbolTable;

int SymbolTableInitialize(SymbolTable *symbolTable);
int SymbolTableAddLet(SymbolTable *symbolTable, char *identifier, Type type);
int SymbolTableAddConst(SymbolTable *symbolTable, char *identifier, Type type);
int SymbolTableAddFunction(SymbolTable *symbolTable, char *identifier, Type returnType, Type *argumentTypes);
Type SymbolTableGetVariableOrConstType(SymbolTable *symbolTable, char *identifier);
Type SymbolTableGetFunctionType(SymbolTable *symbolTable, char *identifier);
int SymbolTablePrintf(SymbolTable *symbolTable);

#endif
