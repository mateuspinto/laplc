#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SYMBOL_TABLE_SIZE 1024
#define IDENTIFIER_ALLOC_SIZE 64

typedef struct
{
  char identifier[IDENTIFIER_ALLOC_SIZE];
} SymbolTableEntry;

int SymbolTableEntryNew(SymbolTableEntry *symbolTableEntry)
{
  strcpy(symbolTableEntry->identifier, "");
  return 0;
}

int SymbolTableIsEmpty(SymbolTableEntry *symbolTableEntry)
{
  return strcmp(symbolTableEntry->identifier, "") == 0 ? 1 : 0;
}

int SymbolTableEntryFill(SymbolTableEntry *symbolTableEntry, char *identifier)
{
  strcpy(symbolTableEntry->identifier, identifier);
  return 0;
}

int SymbolTableEntryTest(SymbolTableEntry *symbolTableEntry, char *identifier)
{
  return strcmp(symbolTableEntry->identifier, identifier) == 0 ? 1 : 0;
}

int SymbolTableEntryPrint(SymbolTableEntry *symbolTableEntry)
{
  return printf("%s\n", symbolTableEntry->identifier);
}

typedef struct
{
  SymbolTableEntry table[SYMBOL_TABLE_SIZE];
  size_t next_empty_slot;
} SymbolTable;

int SymbolTableNew(SymbolTable *symbolTable)
{
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++)
  {
    SymbolTableEntryNew(&(symbolTable->table[i]));
  }

  symbolTable->next_empty_slot = 0;
  return 0;
}

int SymbolTablePrint(SymbolTable *symbolTable)
{
  printf("Symbol Table: <identifier>\n");
  for (size_t i = 0; i < symbolTable->next_empty_slot; i++)
  {
    SymbolTableEntryPrint(&(symbolTable->table[i]));
  }
  return 0;
}

int SymbolTableAddEntry(SymbolTable *symbolTable, char *identifier)
{
  SymbolTableEntryFill(&(symbolTable->table[symbolTable->next_empty_slot]), identifier);
  symbolTable->next_empty_slot++;
  return 0;
}

int SymbolTableExistEntry(SymbolTable *symbolTable, char *identifier)
{
  for (size_t i = 0; i < symbolTable->next_empty_slot; i++)
  {
    if (SymbolTableEntryTest(&(symbolTable->table[i]), identifier))
    {
      return 1;
    }
  }
  return 0;
}

#endif