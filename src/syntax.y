%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "symbol_table.h"
#include "type.h"

typedef struct
{
    int Int;
    double Float;
    bool Bool;
    char Char;
    char *String;
    Type type;

} SemanticValue;
#define YYSTYPE SemanticValue

extern int yylex();
extern int yylineno;

Type lastType = UNDEFINED;

void yyerror(const char* s) 
{
	fprintf(stderr, "\nlaplc error: %s on line %d\n", s, yylineno);
	exit(1);
}

void deerror(const char* s) 
{
	fprintf(stderr, "\nlaplc error: Identifier %s on line %d does not exist\n", s, yylineno);
	exit(1);
}
%}

%token LET
%token CONST
%token FUNCTION
%token TYPE_INT
%token TYPE_FLOAT
%token TYPE_CHAR
%token TYPE_BOOL
%token VALUE_INT
%token VALUE_FLOAT
%token VALUE_BOOL
%token VALUE_CHAR
%token VALUE_STRING
%token IDENTIFIER
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
	| statements run
;

statements: variable_definition
	| const_definition
	| function_declaration
;

type_specifier: TYPE_INT {$$.type = INT;}
	| TYPE_FLOAT {$$.type = FLOAT;}
 	| TYPE_CHAR {$$.type = CHAR;}
	| TYPE_BOOL {$$.type = BOOL;}
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

value: VALUE_INT
	| VALUE_BOOL
	| VALUE_CHAR
	| VALUE_FLOAT
;

element: IDENTIFIER
	| value
	| function_call
;

expression: element
	| element operator expression {
		if($1.type!=$3.type) printf("erro de tipos\n");
	}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS operator expression
;

variable_definition: LET IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON {
			if($4.type!=$6.type) printf("erro %d, %d\n", $4.type, $6.type);
		}
;

const_definition: CONST IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON
;

function_definition: OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW OPEN_BRACE expression CLOSE_BRACE
;

function_types: type_specifier
	| type_specifier COMMA function_types
;

function_definition_parameters: IDENTIFIER
	| IDENTIFIER COMMA function_definition_parameters
;

function_call_parameters: element
	| element COMMA function_call_parameters
;

function_declaration: FUNCTION IDENTIFIER COLON OPEN_PARENTHESIS function_types CLOSE_PARENTHESIS
		type_specifier DEFINITION function_definition SEMICOLON
;

function_call: IDENTIFIER OPEN_PARENTHESIS function_call_parameters CLOSE_PARENTHESIS
;

%%

int main() {
	yyparse();
	printf("laplc: well formed program\n\n");

	return 0;
}
