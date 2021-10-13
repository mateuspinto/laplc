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

SymbolTable localScope;
SymbolTable globalScope;

void yyerror(const char* s) 
{
	fprintf(stderr, "\nlaplc error: %s on line %d\n", s, yylineno);
	exit(1);
}

void deerror(const char* s) 
{
	fprintf(stderr, "\nlaplc error: Syntax error, identifier %s on line %d does not exist\n", s, yylineno);
	exit(1);
}

void dderror(const char* s) 
{
	fprintf(stderr, "\nlaplc error: Syntax error, identifier %s on line %d is double declared\n", s, yylineno);
	exit(1);
}

void typeerror(Type s, Type z) 
{
	printf("laplc error: Semantic error, cannot operate left operand of type ");
	TypePrintf(s);
	printf(" with right operand of type ");
	TypePrintf(z);
	printf(" on line %d\n", yylineno);
	
	exit(1);
}

int type_check(Type a, Type b)
{
	return (a!=b);
}

// smt_expression_error
// laplc error: cannot operate left operand of type Int with right operand of type Float on line 5

// smt_variable_error
// laplc error: cannot define variable of type Int with value of type Float on line 5
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
		if(type_check($1.type, $3.type)) typeerror($1.type, $2.type);
		$$.type=$1.type;
	}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS {$$.type=$2.type;}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS operator expression {
		if(type_check($2.type, $5.type)) typeerror($2.type, $5.type);
		$$.type=$2.type;
	}
;

variable_definition: LET IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON {
			if($4.type!=$6.type) typeerror($4.type, $6.type);
			if(SymbolTableGetVariableOrConstType(&globalScope, $2.String)!=UNDEFINED)
				dderror($2.String);
			SymbolTableAddConst(&globalScope, $2.String, $4.type);
		}
;

const_definition: CONST IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON  {
			if($4.type!=$6.type) typeerror($4.type, $6.type);
			if(SymbolTableGetVariableOrConstType(&globalScope, $2.String)!=UNDEFINED)
				dderror($2.String);
			SymbolTableAddConst(&globalScope, $2.String, $4.type);
		}
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
		type_specifier DEFINITION function_definition SEMICOLON {
			// Do type checking
			SymbolTableInitialize(&localScope);
		}
;

function_call: IDENTIFIER OPEN_PARENTHESIS function_call_parameters CLOSE_PARENTHESIS
;

%%

int main() {
	SymbolTableInitialize(&localScope);
	SymbolTableInitialize(&globalScope);

	yyparse();
	printf("laplc: well formed program\n\n");

	SymbolTablePrintf(&globalScope);

	return 0;
}
