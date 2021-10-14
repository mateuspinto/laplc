BIN=laplc
SRC= src/yacc.tab.c src/lex.yy.c src/type.c src/symbol_table.c src/error_messages.c

CC=gcc
LEX=flex
YACC=bison

CFLAGS=-march=native -O2
LFLAGS=-static
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

run0:
	./$(BIN) < input/0.lapl

run1:
	./$(BIN) < input/1.lapl

run2:
	./$(BIN) < input/2.lapl

run3:
	./$(BIN) < input/3.lapl

run4:
	./$(BIN) < input/4.lapl

run5:
	./$(BIN) < input/5.lapl
	
run6:
	./$(BIN) < input/6.lapl
	
run7:
	./$(BIN) < input/7.lapl
	
run8:
	./$(BIN) < input/8.lapl
	
run9:
	./$(BIN) < input/9.lapl
	
run10:
	./$(BIN) < input/10.lapl
