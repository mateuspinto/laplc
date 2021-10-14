#include "error_messages.h"

void ErrorMessageLexicalError(int yylineno)
{
    printf("laplc: lexical error on line %d\n", yylineno);
    exit(1);
}

void ErrorMessageVariableOrConstDoesNotExist(const char *s, int yylineno)
{
    printf("laplc error: syntax error, variable or const %s does not exist - line %d\n", s, yylineno);
    exit(1);
}

void ErrorMessageFunctionDoesNotExist(const char *s, int yylineno)
{
    printf("laplc error: syntax error, function %s does not exist - line %d\n", s, yylineno);
    exit(1);
}

void ErrorMessageVariableOrConstDoubleDeclaration(const char *s, int yylineno)
{
    printf("laplc error: syntax error, variable or constant %s is double declared on line %d\n", s, yylineno);
    exit(1);
}

void ErrorMessageExpressionTypeError(Type left, Type right, int yylineno)
{
    printf("laplc error: semantic error, expression inviable. Cannot operate left operand of type ");
    TypePrintf(left);
    printf(" with right operand of type ");
    TypePrintf(right);
    printf(" on line %d\n", yylineno);
    exit(1);
}

void ErrorMessageFunctionDeclarationIncorrectArgumentNumber(char *functionName, int expectedArgumentNumber, int giverArgumentNumber, int yylineno)
{
    printf("laplc error: semantic error, function %s has %d parameter types, but only %d parameter identifiers were given on line %d\n", functionName, expectedArgumentNumber, giverArgumentNumber, yylineno);
    exit(1);
}

void ErrorMessageFunctionDoubleDeclaration(const char *s, int yylineno)
{
    printf("laplc error: syntax error, function %s on line %d is double declared\n", s, yylineno);
    exit(1);
}

void ErrorMessageFunctionWrongReturnType(const char *s, Type expectedReturnType, Type givenReturnType, int yylineno)
{
    printf("laplc error: semantic error, function %s is invalid. The expected return type is ", s);
    TypePrintf(expectedReturnType);
    printf(", but the given were ");
    TypePrintf(givenReturnType);
    printf(" on line %d\n", yylineno);
    exit(1);
}

void ErrorMessageFunctionCallDoesNotExist(const char *s, int yylineno)
{
    printf("laplc error: syntax error, function %s on line %d does not exist\n", s, yylineno);
    exit(1);
}

void ErrorMessageFunctionCallIncorrectArgumentNumber(char *functionName, int yylineno)
{
    printf("laplc error: semantic error, function %s argument number error on line %d\n", functionName, yylineno);
    exit(1);
}

void ErrorMessageFunctionCallIncorrectArgumentType(char *functionName, int yylineno)
{
    printf("laplc error: semantic error, function %s has argument type errors on line %d\n", functionName, yylineno);
    exit(1);
}
