%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "symbol_table.h"
#include "type.h"
#include "semantic_value.h"
#include "error_messages.h"

#define YYSTYPE SemanticValue

extern int yylex();
extern int yylineno;

SymbolTable localScope;
SymbolTable globalScope;

Type argumentTypes[MAX_ARGUMENT_NUMBER];
int parameterTypeCounter;
int parameterIdentifierCounter;
int globalTempVariableCounter;
int localTempVariableCounter;

int functionExpressionCounter;
char functionDefinitionBuffer[64][64];
char functionExpressionBuffer[64][64];

void yyerror(const char* s) 
{
	fprintf(stderr, "\nlaplc error: %s on line %d\n", s, yylineno);
	exit(1);
}

void resetArgumentTypes(Type *vec)
{
	for (size_t i = 0; i < MAX_ARGUMENT_NUMBER; i++)
    {
        vec[i] = UNDEFINED;
    }	
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
%token MATCH
%token DEFAULT

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

operator: NOT {strcpy($$.String, "not");}
	| PLUS {strcpy($$.String, "add");}
	| MINUS {strcpy($$.String, "sub");}
	| DIVISION {strcpy($$.String, "div");}
	| MULTIPLICATION {strcpy($$.String, "mul");}
	| MOD {strcpy($$.String, "mod");}
	| EQUAL {strcpy($$.String, "eq");}
	| NOT_EQUAL {strcpy($$.String, "ne");}
	| GREATER {strcpy($$.String, "gt");}
	| LESS {strcpy($$.String, "lt");}
	| GREATER_OR_EQUAL {strcpy($$.String, "ge");}
	| LESS_OR_EQUAL {strcpy($$.String, "le");}
	| AND {strcpy($$.String, "and");}
	| OR {strcpy($$.String, "add");}
;

value: VALUE_INT
	| VALUE_BOOL
	| VALUE_CHAR
	| VALUE_FLOAT
;

element: IDENTIFIER { 
			$$.type=SymbolTableGetVariableOrConstType(&globalScope, $1.String);
			if ($$.type==UNDEFINED) ErrorMessageVariableOrConstDoesNotExist($1.String, yylineno);
			strcpy($$.String, $1.String);
	}
	| value
	| function_call { 
			$$.type=SymbolTableGetFunctionReturnType(&globalScope, $1.String);
			if ($$.type==UNDEFINED) ErrorMessageFunctionDoesNotExist($1.String, yylineno);
	}
;

expression: element
	| element operator expression {
		if ($1.type!=$3.type) ErrorMessageExpressionTypeError($1.type, $3.type, yylineno);
		$$.type=$1.type;
		sprintf($$.String, "_t%d", globalTempVariableCounter);
		printf("%s %s, %s, %s;\n", $2.String, $$.String, $1.String, $3.String);
		globalTempVariableCounter++;
	}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS {
		$$.type=$2.type;
		strcpy($$.String, $2.String);
	}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS operator expression {
		if ($2.type!=$5.type) ErrorMessageExpressionTypeError($2.type, $5.type, yylineno);
		$$.type=$2.type;
		sprintf($$.String, "_t%d", globalTempVariableCounter);
		printf("%s %s, %s, %s;\n", $4.String, $$.String, $2.String, $5.String);
		globalTempVariableCounter++;
	}
;

function_element: IDENTIFIER { 
			$$.type=SymbolTableGetVariableOrConstType(&localScope, $1.String);
			if ($$.type==UNDEFINED) ErrorMessageVariableOrConstDoesNotExist($1.String, yylineno);
			
			// Concating _f to function variables
			strcpy($$.String, "_f");
			for(size_t i=0; i<62; i++){
				$$.String[i+2]=$1.String[i];
			}
	}
	| value
;

function_expression: function_element
	| function_element operator function_expression {
		if ($1.type!=$3.type) ErrorMessageExpressionTypeError($1.type, $3.type, yylineno);
		$$.type=$1.type;
		sprintf($$.String, "_t%d", localTempVariableCounter);
		sprintf(functionExpressionBuffer[functionExpressionCounter],"%s _t%d, %s, %s;\n", $2.String, localTempVariableCounter, $1.String, $3.String);
		localTempVariableCounter++;
		functionExpressionCounter++;
	}
	| OPEN_PARENTHESIS function_expression CLOSE_PARENTHESIS {
		$$.type=$2.type;
		strcpy($$.String, $2.String);
	}
	| OPEN_PARENTHESIS function_expression CLOSE_PARENTHESIS operator function_expression {
		if ($2.type!=$5.type) ErrorMessageExpressionTypeError($2.type, $5.type, yylineno);
		$$.type=$2.type;
		sprintf($$.String, "_t%d", localTempVariableCounter);
		sprintf(functionExpressionBuffer[functionExpressionCounter],"%s _t%d, %s, %s;\n", $2.String, localTempVariableCounter, $1.String, $3.String);
		localTempVariableCounter++;
		functionExpressionCounter++;
	}
;

variable_definition: LET IDENTIFIER COLON type_specifier DEFINITION expression SEMICOLON {
			if ($4.type!=$6.type) ErrorMessageExpressionTypeError($4.type, $6.type, yylineno);
			if (SymbolTableGetVariableOrConstType(&globalScope, $2.String)!=UNDEFINED) ErrorMessageVariableOrConstDoubleDeclaration($2.String, yylineno);
			SymbolTableAddLet(&globalScope, $2.String, $4.type);
			printf("mov %s, %s;\n", $2.String, $6.String);
	}
;

const_definition: CONST IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON  {
			if ($4.type!=$6.type) ErrorMessageExpressionTypeError($4.type, $6.type, yylineno);
			if (SymbolTableGetVariableOrConstType(&globalScope, $2.String)!=UNDEFINED) ErrorMessageVariableOrConstDoubleDeclaration($2.String, yylineno);
			SymbolTableAddConst(&globalScope, $2.String, $4.type);
			printf("mov %s, %s;\n", $2.String, $6.String);
	}
;

guards: function_element operator function_element COLON OPEN_BRACE function_expression CLOSE_BRACE SEMICOLON {$$.type=$6.type;}
	| DEFAULT COLON OPEN_BRACE function_expression CLOSE_BRACE SEMICOLON {$$.type=$4.type;}
	| function_element operator function_element COLON OPEN_BRACE function_expression CLOSE_BRACE SEMICOLON guards {
			if ($9.type!=$6.type) ErrorMessageExpressionTypeError($9.type, $6.type, yylineno);
			$$.type=$5.type;
	}
;

function_definition: OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW OPEN_BRACE function_expression CLOSE_BRACE {
	$$.type=$6.type;
	strcpy($$.String, $6.String);
	}
	| OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW MATCH OPEN_BRACE guards CLOSE_BRACE {$$.type=$7.type;}
;

function_types: type_specifier {
		SymbolTableAddFunctionArgumentType(&globalScope, $1.type);
		argumentTypes[parameterTypeCounter]=$1.type;
		parameterTypeCounter++;
	}
	| type_specifier COMMA function_types {
		SymbolTableAddFunctionArgumentType(&globalScope, $1.type);
		argumentTypes[parameterTypeCounter]=$1.type;
		parameterTypeCounter++;
	}
;

function_definition_parameters: IDENTIFIER {
			SymbolTableAddLet(&localScope, $1.String, argumentTypes[parameterIdentifierCounter]);
			sprintf(functionDefinitionBuffer[parameterIdentifierCounter], "mov _f%s, _a%d;\n", $1.String, parameterIdentifierCounter);
			parameterIdentifierCounter++;
		}
	| IDENTIFIER COMMA function_definition_parameters {
			SymbolTableAddLet(&localScope, $1.String, argumentTypes[parameterIdentifierCounter]);
			sprintf(functionDefinitionBuffer[parameterIdentifierCounter], "mov _f%s, _a%d;\n", $1.String, parameterIdentifierCounter);
			parameterIdentifierCounter++;
		}
;

function_call_parameters: element {
	argumentTypes[parameterTypeCounter]=$1.type;
	parameterTypeCounter++;
	}
	| element COMMA function_call_parameters {
		argumentTypes[parameterTypeCounter]=$1.type;
		parameterTypeCounter++;
	}
;

function_declaration: FUNCTION IDENTIFIER COLON OPEN_PARENTHESIS function_types CLOSE_PARENTHESIS
		type_specifier DEFINITION function_definition SEMICOLON {
			if (SymbolTableGetFunctionReturnType(&globalScope, $2.String)!=UNDEFINED)
				ErrorMessageFunctionDoubleDeclaration($2.String, yylineno);

			if (parameterTypeCounter!=parameterIdentifierCounter) 
				ErrorMessageFunctionDeclarationIncorrectArgumentNumber($2.String, parameterTypeCounter, parameterIdentifierCounter, yylineno);

			if ($7.type!=$9.type)
				ErrorMessageFunctionWrongReturnType($2.String, $7.type, $9.type, yylineno);

			SymbolTableFinishAddFunction(&globalScope, $2.String, $7.type);
			printf("%s:\n", $2.String);
			for(size_t i=0; i<parameterIdentifierCounter; i++){
				printf("%s", functionDefinitionBuffer[i]);
			}
			for(size_t i=0; i<functionExpressionCounter; i++){
				printf("%s", functionExpressionBuffer[i]);
			}
			printf("mov _r, %s;\n", $9.String);
			printf("jr;\n");
			SymbolTableInitialize(&localScope);
			resetArgumentTypes(argumentTypes);
			parameterTypeCounter=0;
			parameterIdentifierCounter=0;	
			localTempVariableCounter=0;
			functionExpressionCounter=0;
		}
;

function_call: IDENTIFIER OPEN_PARENTHESIS function_call_parameters CLOSE_PARENTHESIS {
			if (SymbolTableGetFunctionReturnType(&globalScope, $1.String)==UNDEFINED) ErrorMessageFunctionDoesNotExist($1.String, yylineno);

			switch (SymbolTableTestFunctionArgumentTypes(&globalScope, $1.String, argumentTypes, parameterTypeCounter))
			{
			case 1:
				ErrorMessageFunctionCallIncorrectArgumentType($1.String, yylineno);
				break;

			case 2:
				ErrorMessageFunctionCallIncorrectArgumentNumber($1.String, yylineno);
				break;

			case 3:
				ErrorMessageFunctionCallDoesNotExist($1.String, yylineno);
				break;

			default:
				break;
			}

			parameterTypeCounter = 0;
		}
;

%%

int main() {
	SymbolTableInitialize(&localScope);
	SymbolTableInitialize(&globalScope);

	resetArgumentTypes(argumentTypes);

	parameterTypeCounter=0;
	parameterIdentifierCounter=0;
	globalTempVariableCounter=0;
	localTempVariableCounter=0;
	functionExpressionCounter=0;

	yyparse();
	printf("laplc: well formed program\n\n");

	printf("Global Symbol Table:\n");
	SymbolTablePrintf(&globalScope);

	return 0;
}
