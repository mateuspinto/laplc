#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SYMBOL_TABLE_SIZE 1024

typedef struct {
  char *identifier;
} SymbolTableEntry;

int SymbolTableEntryNew(SymbolTableEntry *symbolTableEntry) {
  symbolTableEntry->identifier = NULL;
  return 0;
}

int SymbolTableEntryFill(SymbolTableEntry *symbolTableEntry, char *identifier) {
  symbolTableEntry->identifier =
      (char *)malloc(strlen(identifier) * sizeof(char));

  if (symbolTableEntry->identifier != NULL) {
    strcpy(symbolTableEntry->identifier, identifier);
    return 0;
  } else {
    return 1;
  }
}

int SymbolTableEntryTest(SymbolTableEntry *symbolTableEntry, char *identifier) {
  return strcmp(symbolTableEntry->identifier, identifier) == 0 ? 1 : 0;
}

int SymbolTableEntryPrint(SymbolTableEntry *symbolTableEntry) {
  return printf("%s\n", symbolTableEntry->identifier);
}

typedef struct {
  SymbolTableEntry table[SYMBOL_TABLE_SIZE];
} SymbolTable;

int SymbolTableNew(SymbolTable *symbolTable) {
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++) {
    SymbolTableEntryNew(&(symbolTable->table[i]));
  }

  return 0;
}

int SymbolTablePrint(SymbolTable *symbolTable) {
  printf("Identifier\n");

  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++) {
    if (symbolTable->table[i].identifier != NULL) {
      SymbolTableEntryPrint(&(symbolTable->table[i]));
    }
  }

  return 0;
}

int SymbolTableNewEntry(SymbolTable *symbolTable, char *identifier) {
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++) {
    if (symbolTable->table[i].identifier == NULL) {
      SymbolTableEntryFill(&(symbolTable->table[i]), identifier);
      return 0;
    }
  }

  return 1;
}

int SymbolTableEntryExists(SymbolTable *symbolTable, char *identifier) {
  for (size_t i = 0; i < SYMBOL_TABLE_SIZE; i++) {
    if (symbolTable->table[i].identifier == NULL) {
      return 0;
    }

    if (SymbolTableEntryTest(&(symbolTable->table[i]), identifier)) {
      return 1;
    }
  }

  return 0;
}

#endif