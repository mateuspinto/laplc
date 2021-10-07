%{
#define YYSTYPE char*
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YY_DECL int yylex()

#include "yacc.tab.h"

char * copy_semantic_value(char * yytext, int yyleng)
{
    char * to_bison = (char *) malloc((yyleng+1)*sizeof(char));
    strcpy(to_bison, yytext);
    return to_bison;
}
%}

%option noyywrap
%option yylineno

let let
const const
function function
import import 
as as
from from
match match
data data
default default

type_int Int
type_float Float
type_char Char
type_bool Bool
type_struct Struct

open_parenthesis "("
close_parenthesis ")"

open_bracket "["
close_bracket "]"

open_brace "{"
close_brace "}"

arrow "=>"
colon ":"
comma ","
semicolon ";"
period "."
definition "="

not "!"
plus "+"
minus "-"
division "/"
multiplication "*"
pow "**"
mod "%"
equal "=="
not_equal "!="
greater ">"
less "<"
greater_or_equal ">="
less_or_equal "<="
and "&"
or "|"

digit [0-9]
number {digit}+
lowercase [a-z]
uppercase [A-Z]

value_int {number}
value_float {number}"."{number}
value_bool False|True
value_char \'(.)\'
value_string \"(.)*\"

lowercase_identifier {lowercase}({lowercase}|{uppercase}|{digit})*
uppercase_identifier {uppercase}({lowercase}|{uppercase}|{digit})*

%%
"#"(.)*\n {}
[ \t\n]+ {}

{let} {printf("lex <LET, %s>\n", yytext); return LET;}
{const} {printf("lex <CONST, %s>\n", yytext); return CONST;}
{function} {printf("lex <FUNCTION, %s>\n", yytext); return FUNCTION;}
{import} {printf("lex <IMPORT, %s>\n", yytext); return IMPORT;}
{as} {printf("lex <AS, %s>\n", yytext); return AS;}
{from} {printf("lex <FROM, %s>\n", yytext); return FROM;}
{match} {printf("lex <MATCH, %s>\n", yytext); return MATCH;}
{data} {printf("lex <DATA, %s>\n", yytext); return DATA;}
{default} {printf("lex <DEFAULT, %s>\n", yytext); return DEFAULT;}

{type_int} {printf("lex <TYPE_INT, %s>\n", yytext); return TYPE_INT;}
{type_float} {printf("lex <TYPE_FLOAT, %s>\n", yytext); return TYPE_FLOAT;}
{type_char} {printf("lex <TYPE_CHAR, %s>\n", yytext); return TYPE_CHAR;}
{type_bool} {printf("lex <TYPE_BOOL, %s>\n", yytext); return TYPE_BOOL;}
{type_struct} {printf("lex <TYPE_STRUCT, %s>\n", yytext); return TYPE_STRUCT;}

{open_parenthesis} {printf("lex <OPEN_PARENTHESIS, %s>\n", yytext); return OPEN_PARENTHESIS;}
{close_parenthesis} {printf("lex <CLOSE_PARENTHESIS, %s>\n", yytext); return CLOSE_PARENTHESIS;}

{open_bracket} {printf("lex <OPEN_BRACKET, %s>\n", yytext); return OPEN_BRACKET;}
{close_bracket} {printf("lex <CLOSE_BRACKET, %s>\n", yytext); return CLOSE_BRACKET;}

{open_brace} {printf("lex <OPEN_BRACE, %s>\n", yytext); return OPEN_BRACE;}
{close_brace} {printf("lex <CLOSE_BRACE, %s>\n", yytext); return CLOSE_BRACE;}

{arrow} {printf("lex <ARROW, %s>\n", yytext); return ARROW;}
{colon} {printf("lex <COLON, %s>\n", yytext); return COLON;}
{comma} {printf("lex <COMMA, %s>\n", yytext); return COMMA;}
{semicolon} {printf("lex <SEMICOLON, %s>\n", yytext); return SEMICOLON;}
{period} {printf("lex <PERIOD, %s>\n", yytext); return PERIOD;}
{definition} {printf("lex <DEFINITION, %s>\n", yytext); return DEFINITION;}

{not} {printf("lex <NOT, %s>\n", yytext); return NOT;}
{plus} {printf("lex <PLUS, %s>\n", yytext); return PLUS;}
{minus} {printf("lex <MINUS, %s>\n", yytext); return MINUS;}
{division} {printf("lex <DIVISION, %s>\n", yytext); return DIVISION;}
{multiplication} {printf("lex <MULTIPLICATION, %s>\n", yytext); return MULTIPLICATION;}
{pow} {printf("lex <POW, %s>\n", yytext); return POW;}
{mod} {printf("lex <MOD, %s>\n", yytext); return MOD;}
{equal} {printf("lex <EQUAL, %s>\n", yytext); return EQUAL;}
{not_equal} {printf("lex <NOT_EQUAL, %s>\n", yytext); return NOT_EQUAL;}
{greater} {printf("lex <GREATER, %s>\n", yytext); return GREATER;}
{less} {printf("lex <LESS, %s>\n", yytext); return LESS;}
{greater_or_equal} {printf("lex <GREATER_OR_EQUAL, %s>\n", yytext); return GREATER_OR_EQUAL;}
{less_or_equal} {printf("lex <LESS_OR_EQUAL, %s>\n", yytext); return LESS_OR_EQUAL;}
{and} {printf("lex <AND, %s>\n", yytext); return AND;}
{or} {printf("lex <OR, %s>\n", yytext); return OR;}

{value_int} {printf("lex <VALUE_INT, %s>\n", yytext); return VALUE_INT;}
{value_float} {printf("lex <VALUE_FLOAT, %s>\n", yytext); return VALUE_FLOAT;}
{value_bool} {printf("lex <VALUE_BOOL, %s>\n", yytext); return VALUE_BOOL;}
{value_char} {printf("lex <VALUE_CHAR, %s>\n", yytext); return VALUE_CHAR;}
{value_string} {printf("lex <VALUE_STRING, %s>\n", yytext); return VALUE_STRING;}

{lowercase_identifier} {printf("lex <LOWERCASE_IDENTIFIER, %s>\n", yytext); yylval = copy_semantic_value(yytext, yyleng); return LOWERCASE_IDENTIFIER;}
{uppercase_identifier} {printf("lex <UPPERCASE_IDENTIFIER, %s>\n", yytext); return UPPERCASE_IDENTIFIER;}

. {printf("laplc: lexical error on line %d\n", yylineno); exit(1);}

%%
