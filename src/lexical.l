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
    if (to_bison!=NULL) {
        strcpy(to_bison, yytext);
    }
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

{let} {return LET;}
{const} {return CONST;}
{function} {return FUNCTION;}
{import} {return IMPORT;}
{as} {return AS;}
{from} {return FROM;}
{match} {return MATCH;}
{data} {return DATA;}
{default} {return DEFAULT;}

{type_int} {return TYPE_INT;}
{type_float} {return TYPE_FLOAT;}
{type_char} {return TYPE_CHAR;}
{type_bool} {return TYPE_BOOL;}
{type_struct} {return TYPE_STRUCT;}

{open_parenthesis} {return OPEN_PARENTHESIS;}
{close_parenthesis} {return CLOSE_PARENTHESIS;}

{open_bracket} {return OPEN_BRACKET;}
{close_bracket} {return CLOSE_BRACKET;}

{open_brace} {return OPEN_BRACE;}
{close_brace} {return CLOSE_BRACE;}

{arrow} {return ARROW;}
{colon} {return COLON;}
{comma} {return COMMA;}
{semicolon} {return SEMICOLON;}
{period} {return PERIOD;}
{definition} {return DEFINITION;}

{not} {return NOT;}
{plus} {return PLUS;}
{minus} {return MINUS;}
{division} {return DIVISION;}
{multiplication} {return MULTIPLICATION;}
{pow} {return POW;}
{mod} {return MOD;}
{equal} {return EQUAL;}
{not_equal} {return NOT_EQUAL;}
{greater} {return GREATER;}
{less} {return LESS;}
{greater_or_equal} {return GREATER_OR_EQUAL;}
{less_or_equal} {return LESS_OR_EQUAL;}
{and} {return AND;}
{or} {return OR;}

{value_int} {return VALUE_INT;}
{value_float} {return VALUE_FLOAT;}
{value_bool} {return VALUE_BOOL;}
{value_char} {return VALUE_CHAR;}
{value_string} {return VALUE_STRING;}

{lowercase_identifier} {yylval = copy_semantic_value(yytext, yyleng); return LOWERCASE_IDENTIFIER;}
{uppercase_identifier} {yylval = copy_semantic_value(yytext, yyleng); return UPPERCASE_IDENTIFIER;}

. {printf("laplc: lexical error on line %d\n", yylineno); exit(1);}

%%
