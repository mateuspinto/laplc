BIN=laplc
SRC= src/yacc.tab.c src/lex.yy.c src/type.c src/symbol_table.c src/error_messages.c

CC=gcc
LEX=flex
YACC=bison

CFLAGS=
LFLAGS=
WARN=

all: yacc lex compile

yacc:
	$(YACC) -t -o src/yacc.tab.c -d src/syntax.y

lex:
	$(LEX) -o src/lex.yy.c src/lexical.l

compile:
	$(CC) -o $(BIN) $(SRC) $(CFLAGS) $(LFLAGS)

run:
	./$(BIN)
