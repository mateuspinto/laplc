%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "symbol_table.h"
#include "type.h"

typedef struct
{
    char String[64];
    Type type;

} SemanticValue;
#define YYSTYPE SemanticValue

extern int yylex();
extern int yylineno;

SymbolTable localScope;
SymbolTable globalScope;

Type vecTypes[MAX_ARGUMENT_NUMBER];
int numeroArgumentos;
int identifierNumber;
int actualTempVar;
int functionExpressionCounter;

char functionDefinitionBuffer[64][64];
char functionExpressionBuffer[64][64];

int localActualTempVar;

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

void resetVecTypes(Type *vec)
{
	for (size_t i = 0; i < MAX_ARGUMENT_NUMBER; i++)
    {
        vec[i] = UNDEFINED;
    }	
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

operator: NOT
	| PLUS {strcpy($$.String, "add");}
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

element: IDENTIFIER { 
			$$.type=SymbolTableGetVariableOrConstType(&globalScope, $1.String);
			if($$.type==UNDEFINED)
				deerror($1.String);
			strcpy($$.String, $1.String);
			
		}
	| value
	| function_call { 
			$$.type=SymbolTableGetFunctionReturnType(&globalScope, $1.String);
			if($$.type==UNDEFINED)
				deerror($1.String);
		}
;

expression: element
	| element operator expression {
		if(type_check($1.type, $3.type)) typeerror($1.type, $3.type);
		$$.type=$1.type;
		sprintf($$.String, "_t%d", actualTempVar);
		printf("%s %s, %s, %s;\n", $2.String, $$.String, $1.String, $3.String);
		actualTempVar++;
	}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS {$$.type=$2.type;strcpy($$.String, $2.String);}
	| OPEN_PARENTHESIS expression CLOSE_PARENTHESIS operator expression {
		if(type_check($2.type, $5.type)) typeerror($2.type, $5.type);
		$$.type=$2.type;
		sprintf($$.String, "_t%d", actualTempVar);
		printf("%s %s, %s, %s;\n", $4.String, $$.String, $2.String, $5.String);
		actualTempVar++;
	}
;

function_element: IDENTIFIER { 
			$$.type=SymbolTableGetVariableOrConstType(&localScope, $1.String);
			if($$.type==UNDEFINED)
				deerror($1.String);
			strcpy($$.String, "_f");
			for(size_t i=0; i<62; i++){
				$$.String[i+2]=$1.String[i];
			}
			
		}
	| value
;

function_expression: function_element
	| function_element operator function_expression {
		if(type_check($1.type, $3.type)) typeerror($1.type, $3.type);
		$$.type=$1.type;
		sprintf($$.String, "_t%d", localActualTempVar);
		sprintf(functionExpressionBuffer[functionExpressionCounter],"%s _t%d, %s, %s;\n", $2.String, localActualTempVar, $1.String, $3.String);
		localActualTempVar++;
		functionExpressionCounter++;
		actualTempVar++;
	}
	| OPEN_PARENTHESIS function_expression CLOSE_PARENTHESIS {$$.type=$2.type;strcpy($$.String, $2.String);}
	| OPEN_PARENTHESIS function_expression CLOSE_PARENTHESIS operator function_expression {
		if(type_check($2.type, $5.type)) typeerror($2.type, $5.type);
		$$.type=$2.type;
		sprintf($$.String, "_t%d", localActualTempVar);
		sprintf(functionExpressionBuffer[functionExpressionCounter],"%s _t%d, %s, %s;\n", $2.String, localActualTempVar, $1.String, $3.String);
		localActualTempVar++;
		functionExpressionCounter++;
		actualTempVar++;
	}
;

variable_definition: LET IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON {
			if($4.type!=$6.type) typeerror($4.type, $6.type);
			if(SymbolTableGetVariableOrConstType(&globalScope, $2.String)!=UNDEFINED)
				dderror($2.String);
			SymbolTableAddLet(&globalScope, $2.String, $4.type);
			printf("mov %s, %s;\n", $2.String, $6.String);
		}
;

const_definition: CONST IDENTIFIER COLON type_specifier 
		DEFINITION expression SEMICOLON  {
			if($4.type!=$6.type) typeerror($4.type, $6.type);
			if(SymbolTableGetVariableOrConstType(&globalScope, $2.String)!=UNDEFINED)
				dderror($2.String);
			SymbolTableAddConst(&globalScope, $2.String, $4.type);
			printf("mov %s, %s;\n", $2.String, $6.String);
		}
;

guards: function_element operator function_element COLON OPEN_BRACE function_expression CLOSE_BRACE SEMICOLON {$$.type=$6.type;}
	| DEFAULT COLON OPEN_BRACE function_expression CLOSE_BRACE SEMICOLON {$$.type=$4.type;}
	| function_element operator function_element COLON OPEN_BRACE function_expression CLOSE_BRACE SEMICOLON guards {
			if($9.type!=$6.type)
				typeerror($9.type, $6.type);
			$$.type=$5.type;
		}
;

function_definition: OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW OPEN_BRACE function_expression CLOSE_BRACE {$$.type=$6.type; strcpy($$.String, $6.String);}
	| OPEN_PARENTHESIS function_definition_parameters CLOSE_PARENTHESIS ARROW MATCH OPEN_BRACE guards CLOSE_BRACE {$$.type=$7.type;}
;

function_types: type_specifier {SymbolTableAddFunctionArgumentType(&globalScope, $1.type); vecTypes[numeroArgumentos]=$1.type; numeroArgumentos++;}
	| type_specifier COMMA function_types {SymbolTableAddFunctionArgumentType(&globalScope, $1.type); vecTypes[numeroArgumentos]=$1.type; numeroArgumentos++;}
;

function_definition_parameters: IDENTIFIER {
			SymbolTableAddLet(&localScope, $1.String, vecTypes[identifierNumber]);
			sprintf(functionDefinitionBuffer[identifierNumber], "mov _f%s, _a%d;\n", $1.String, identifierNumber);
			identifierNumber++;
		}
	| IDENTIFIER COMMA function_definition_parameters {
			SymbolTableAddLet(&localScope, $1.String, vecTypes[identifierNumber]);
			sprintf(functionDefinitionBuffer[identifierNumber], "mov _f%s, _a%d;\n", $1.String, identifierNumber);
			identifierNumber++;
		}
;

function_call_parameters: element {vecTypes[numeroArgumentos]=$1.type; numeroArgumentos++;}
	| element COMMA function_call_parameters {vecTypes[numeroArgumentos]=$1.type; numeroArgumentos++;}
;

function_declaration: FUNCTION IDENTIFIER COLON OPEN_PARENTHESIS function_types CLOSE_PARENTHESIS
		type_specifier DEFINITION function_definition SEMICOLON {
			if(SymbolTableGetFunctionReturnType(&globalScope, $2.String)==UNDEFINED){
				if(numeroArgumentos!=identifierNumber){
					printf("Number of parameters is different from number of definitions\n");
					exit(1);
				}
				if($7.type!=$9.type){
					printf("Function return is different from defined return\n");
					exit(1);
				}
				SymbolTableFinishAddFunction(&globalScope, $2.String, $7.type);
				printf("%s:\n", $2.String);
				for(size_t i=0; i<identifierNumber; i++){
					printf("%s", functionDefinitionBuffer[i]);
				}
				for(size_t i=0; i<functionExpressionCounter; i++){
					printf("%s", functionExpressionBuffer[i]);
				}
				printf("mov _r, %s;\n", $9.String);
				printf("jr;\n");
				SymbolTableInitialize(&localScope);
				resetVecTypes(vecTypes);
				numeroArgumentos=0;
				identifierNumber=0;	
				localActualTempVar=0;
				functionExpressionCounter=0;
			}else{
				dderror($2.String);
			}
		}
;

function_call: IDENTIFIER OPEN_PARENTHESIS function_call_parameters CLOSE_PARENTHESIS {
			if(SymbolTableGetFunctionReturnType(&globalScope, $1.String)==UNDEFINED){
				deerror($1.String);	
			}else{
				if(SymbolTableTestFunctionArgumentTypes(&globalScope, $1.String, vecTypes, numeroArgumentos)!=-1){
					printf("Deu bosta %d\n", SymbolTableTestFunctionArgumentTypes(&globalScope, $1.String, vecTypes, numeroArgumentos));
					exit(1);
				}
			}
		}
;

%%

int main() {
	SymbolTableInitialize(&localScope);
	SymbolTableInitialize(&globalScope);

	resetVecTypes(vecTypes);

	numeroArgumentos=0;
	identifierNumber=0;
	actualTempVar=0;
	localActualTempVar=0;
	functionExpressionCounter=0;

	yyparse();
	printf("laplc: well formed program\n\n");

	printf("Global Symbol Table:\n");
	SymbolTablePrintf(&globalScope);

	return 0;
}
