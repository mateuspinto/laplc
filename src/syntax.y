%{
#define YYSTYPE char*
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno;
void yyerror(const char* s);
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
;

vec_type: OPEN_BRACKET type_specifier SEMICOLON VALUE_INT CLOSE_BRACKET
;

type_specifier: TYPE_INT
	| TYPE_FLOAT
 	| TYPE_CHAR
	| TYPE_BOOL 
	| vec_type
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

value: VALUE_INT
	| VALUE_BOOL
	| VALUE_CHAR
	| VALUE_FLOAT
	| value_vec
;

parameter: LOWERCASE_IDENTIFIER
	| value
	| function_call
;

expression: parameter
	| parameter operator expression
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS operator expression
;

variable_definition: LET LOWERCASE_IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON {printf("%s\n", $2); free($2);}
;

const_definition: CONST LOWERCASE_IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON
;

guards: parameter operator parameter COLON OPEN_BRACE parameter CLOSE_BRACE SEMICOLON
	| parameter operator parameter COLON OPEN_BRACE parameter CLOSE_BRACE SEMICOLON guards
	| DEFAULT COLON OPEN_BRACE parameter CLOSE_BRACE SEMICOLON
;

function_definition: OPEN_PARENTHESIS function_parameters CLOSE_PARENTHESIS ARROW MATCH OPEN_BRACE guards CLOSE_BRACE
	| OPEN_PARENTHESIS function_parameters CLOSE_PARENTHESIS ARROW OPEN_BRACE expression CLOSE_BRACE
;

function_types: type_specifier
	| type_specifier COMMA function_types
;

function_parameters: parameter
	| parameter COMMA function_parameters
;

function_declaration: FUNCTION LOWERCASE_IDENTIFIER COLON OPEN_PARENTHESIS function_types CLOSE_PARENTHESIS
		type_specifier DEFINITION function_definition SEMICOLON
;

function_call: LOWERCASE_IDENTIFIER OPEN_PARENTHESIS function_parameters CLOSE_PARENTHESIS
;

%%

void yyerror(const char* s) {
	fprintf(stderr, "laplc: %s on line %d\n", s, yylineno);
}

int main() {
	return yyparse();
}

