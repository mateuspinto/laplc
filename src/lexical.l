%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
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
#define YY_DECL int yylex()
#include "yacc.tab.h"

char * copy_lexem(char * yytext, int yyleng)
{
    char * to_bison = (char *) malloc((yyleng+1)*sizeof(char));
    if (to_bison!=NULL) {
        strcpy(to_bison, yytext);
    }
    return to_bison;
}

char * swapStringToBeCasted = NULL;
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
    swapStringToBeCasted = copy_lexem(yytext, yyleng);
    yylval.Int = atoi(swapStringToBeCasted);

    free(swapStringToBeCasted);
    swapStringToBeCasted = NULL;

    return VALUE_INT;
    }

{value_float} {
    yylval.type = FLOAT;
    swapStringToBeCasted = copy_lexem(yytext, yyleng);
    yylval.Float = strtod(swapStringToBeCasted, NULL);

    free(swapStringToBeCasted);
    swapStringToBeCasted = NULL;

    return VALUE_FLOAT;
    }

{value_bool} {
    yylval.type = BOOL;
    swapStringToBeCasted = copy_lexem(yytext, yyleng);
    
    switch (strcmp(swapStringToBeCasted, "True") == 0 ? 1 : 0)
    {
    case 1:
        yylval.Bool = 1;
        break;

    case 2:
        yylval.Bool = 0;
        break;

    default:
        break;
    }

    free(swapStringToBeCasted);
    swapStringToBeCasted = NULL;

    return VALUE_BOOL;
    }

{value_char} {
    yylval.type = CHAR;
    yylval.Char = yytext[1];

    return VALUE_CHAR;
    }

{identifier} {
    yylval.type = STRING;
    yylval.String = copy_lexem(yytext, yyleng); 
    return IDENTIFIER;
    }

. {printf("laplc: lexical error on line %d\n", yylineno); exit(1);}

%%
