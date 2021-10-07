%{
#define YYSTYPE char*
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"

int yydebug = 1;

extern int yylex();
extern int yylineno;

void yyerror(const char* s) {
	fprintf(stderr, "\nlaplc error: %s on line %d\n", s, yylineno);
	exit(1);
}

void deerror(const char* s) {
	fprintf(stderr, "\nlaplc error: Identifier %s on line %d does not exist\n", s, yylineno);
	exit(1);
}

SymbolTable symbolTable;
%}

%token LET
%token CONST
%token FUNCTION
%token IMPORT
%token AS
%token FROM
%token MATCH
%token DATA
%token DEFAULT
%token TYPE_STRUCT
%token TYPE_INT
%token TYPE_FLOAT
%token TYPE_CHAR
%token TYPE_BOOL
%token VALUE_INT
%token VALUE_FLOAT
%token VALUE_BOOL
%token VALUE_CHAR
%token VALUE_STRING
%token LOWERCASE_IDENTIFIER
%token UPPERCASE_IDENTIFIER
%token NOT
%token PLUS
%token MINUS
%token DIVISION
%token MULTIPLICATION
%token MOD
%token EQUAL
%token NOT_EQUAL
%token GREATER
%token LESS
%token GREATER_OR_EQUAL
%token LESS_OR_EQUAL
%token AND
%token OR
%token OPEN_PARENTHESIS
%token CLOSE_PARENTHESIS
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token OPEN_BRACE
%token CLOSE_BRACE
%token ARROW
%token COLON
%token COMMA
%token SEMICOLON
%token PERIOD
%token DEFINITION
%token POW

%start run
%%

run: 
	| list run
;

list: variable_definition
	| const_definition
	| function_declaration
	| data_declariation
	| function_import
;

vec_type: OPEN_BRACKET type_specifier SEMICOLON VALUE_INT CLOSE_BRACKET
;

type_specifier: TYPE_INT
	| TYPE_FLOAT
 	| TYPE_CHAR
	| TYPE_BOOL 
	| TYPE_STRUCT
	| vec_type
	| UPPERCASE_IDENTIFIER {free($1);}
;

operator: NOT
	| PLUS
	| MINUS
	| DIVISION
	| MULTIPLICATION
	| MOD
	| EQUAL
	| NOT_EQUAL
	| GREATER
	| LESS
	| GREATER_OR_EQUAL
	| LESS_OR_EQUAL
	| AND
	| OR
;

aux_value_vec: value
	| value COMMA aux_value_vec
;

value_vec: OPEN_BRACKET aux_value_vec CLOSE_BRACKET
;

aux_struct_value: LOWERCASE_IDENTIFIER COLON value {free($1);}
	| LOWERCASE_IDENTIFIER COLON value COMMA aux_struct_value {free($1);}
;

struct_value: OPEN_BRACE aux_struct_value CLOSE_BRACE
;

value: VALUE_INT
	| VALUE_BOOL
	| VALUE_CHAR
	| VALUE_FLOAT
	| VALUE_STRING
	| value_vec
	| struct_value
;

parameter: LOWERCASE_IDENTIFIER  {
				if(!SymbolTableExistEntry(&symbolTable, $1))
					deerror($1);
				free($1);
			}
	| value
	| fluent_api
	| function_call
;

expression: parameter
	| parameter operator expression
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS operator expression
;

variable_definition: LET LOWERCASE_IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON {
				if(!SymbolTableExistEntry(&symbolTable, $2))
					SymbolTableAddEntry(&symbolTable, $2);
				free($2);
			}
;

const_definition: CONST LOWERCASE_IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON {
				if(!SymbolTableExistEntry(&symbolTable, $2))
					SymbolTableAddEntry(&symbolTable, $2);
				free($2);
			}
;

guards: parameter operator parameter COLON OPEN_BRACE parameter CLOSE_BRACE SEMICOLON
	| parameter operator parameter COLON OPEN_BRACE parameter CLOSE_BRACE SEMICOLON guards
	| DEFAULT COLON OPEN_BRACE parameter CLOSE_BRACE SEMICOLON
;

function_definition: OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW MATCH OPEN_BRACE guards CLOSE_BRACE
	| OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW OPEN_BRACE expression CLOSE_BRACE
;

function_types: type_specifier
	| type_specifier COMMA function_types
;

function_definition_parameters: LOWERCASE_IDENTIFIER {SymbolTableAddEntry(&symbolTable, $1); free($1);}
	| LOWERCASE_IDENTIFIER COMMA function_definition_parameters {SymbolTableAddEntry(&symbolTable, $1); free($1);}
;

function_call_parameters: parameter
	| parameter COMMA function_call_parameters
;

function_declaration: FUNCTION LOWERCASE_IDENTIFIER COLON OPEN_PARENTHESIS function_types CLOSE_PARENTHESIS
		type_specifier DEFINITION function_definition SEMICOLON {
				if(!SymbolTableExistEntry(&symbolTable, $2))
					SymbolTableAddEntry(&symbolTable, $2);
				free($2);
			}
;

fluent_api: PERIOD LOWERCASE_IDENTIFIER {
				if(!SymbolTableExistEntry(&symbolTable, $2))
					deerror($2);
				free($2);
			}
	| LOWERCASE_IDENTIFIER fluent_api {
				if(!SymbolTableExistEntry(&symbolTable, $1))
					deerror($1);
				free($1);
			}
	| UPPERCASE_IDENTIFIER fluent_api {
				if(!SymbolTableExistEntry(&symbolTable, $1))
					deerror($1);
				free($1);
			}
;

aux_function_call: fluent_api OPEN_PARENTHESIS function_call_parameters CLOSE_PARENTHESIS
	| LOWERCASE_IDENTIFIER OPEN_PARENTHESIS function_call_parameters CLOSE_PARENTHESIS {
				if(!SymbolTableExistEntry(&symbolTable, $1))
					deerror($1);
				free($1);
			}
;

function_call: aux_function_call
;

aux_struct_definition: LOWERCASE_IDENTIFIER COLON type_specifier {
				if(!SymbolTableExistEntry(&symbolTable, $1))
					SymbolTableAddEntry(&symbolTable, $1);
				free($1);
					
			}
	| LOWERCASE_IDENTIFIER COLON type_specifier COMMA aux_struct_definition {
				if(!SymbolTableExistEntry(&symbolTable, $1))
					SymbolTableAddEntry(&symbolTable, $1);
				free($1);
			}
;

struct_definition: OPEN_BRACE aux_struct_definition CLOSE_BRACE
;

data_declariation: DATA UPPERCASE_IDENTIFIER COLON TYPE_STRUCT DEFINITION struct_definition SEMICOLON {
				if(!SymbolTableExistEntry(&symbolTable, $2))
					SymbolTableAddEntry(&symbolTable, $2);
				free($2);
			}
;

function_package: LOWERCASE_IDENTIFIER {SymbolTableAddEntry(&symbolTable, $1); free($1);}
	| LOWERCASE_IDENTIFIER COMMA function_package {SymbolTableAddEntry(&symbolTable, $1); free($1);}
;

function_import: FROM UPPERCASE_IDENTIFIER IMPORT function_package {free($2);}
;

%%

int main() {
	SymbolTableNew(&symbolTable);
	yyparse();

	printf("laplc: well formed program\n\n");
	SymbolTablePrint(&symbolTable);

	return 0;
}
