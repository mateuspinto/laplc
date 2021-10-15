#ifndef ERROR_MESSAGES_H
#define ERROR_MESSAGES_H

#include <stdio.h>
#include <stdlib.h>
#include "type.h"

void ErrorMessageLexicalError(int yylineno);
void ErrorMessageVariableOrConstDoesNotExist(const char *s, int yylineno);
void ErrorMessageFunctionDoesNotExist(const char *s, int yylineno);
void ErrorMessageVariableOrConstDoubleDeclaration(const char *s, int yylineno);
void ErrorMessageExpressionTypeError(Type left, Type right, int yylineno);
void ErrorMessageFunctionDeclarationIncorrectArgumentNumber(char *functionName, int expectedArgumentNumber, int giverArgumentNumber, int yylineno);
void ErrorMessageFunctionDoubleDeclaration(const char *s, int yylineno);
void ErrorMessageFunctionWrongReturnType(const char *s, Type expectedReturnType, Type givenReturnType, int yylineno);
void ErrorMessageFunctionCallDoesNotExist(const char *s, int yylineno);
void ErrorMessageFunctionCallIncorrectArgumentNumber(char *functionName, int yylineno);
void ErrorMessageFunctionCallIncorrectArgumentType(char *functionName, int yylineno);

#endif
