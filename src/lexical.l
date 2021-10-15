%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "error_messages.h"
#include "type.h"
#include "semantic_value.h"

#define YYSTYPE SemanticValue
#include "yacc.tab.h"

void copy_lexem(char *result, char * yytext, int yyleng)
{
    for(size_t i=0; i<yyleng; i++){
        result[i]=yytext[i];
    }
    result[yyleng]='\0';
}
%}

%option noyywrap
%option yylineno

let let
const const
function function
match match
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

identifier {lowercase}({lowercase}|{uppercase}|{digit})*

%%
"#"(.)*\n {}
[ \t\n]+ {}

{let} {return LET;}
{const} {return CONST;}
{function} {return FUNCTION;}

{type_int} {return TYPE_INT;}
{type_float} {return TYPE_FLOAT;}
{type_char} {return TYPE_CHAR;}
{type_bool} {return TYPE_BOOL;}

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

{match} {return MATCH;}
{default} {return DEFAULT;}

{value_int} {
    yylval.type = INT;
    copy_lexem(yylval.String, yytext, yyleng);
    return VALUE_INT;
    }

{value_float} {
    yylval.type = FLOAT;
    copy_lexem(yylval.String, yytext, yyleng);
    return VALUE_FLOAT;
    }

{value_bool} {
    yylval.type = BOOL;
    copy_lexem(yylval.String, yytext, yyleng);
    return VALUE_BOOL;
    }

{value_char} {
    yylval.type = CHAR;
    copy_lexem(yylval.String, yytext, yyleng);
    return VALUE_CHAR;
    }

{identifier} {
    yylval.type = STRING;
    copy_lexem(yylval.String, yytext, yyleng); 
    return IDENTIFIER;
    }

. {ErrorMessageLexicalError(yylineno);}

%%
