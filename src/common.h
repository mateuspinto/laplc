#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno;
void yyerror(const char* s);

#define YY_DECL int yylex()

#include "yacc.tab.h"