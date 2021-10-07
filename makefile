all:
	bison -o src/yacc.tab.c -d src/syntax.y && flex -o src/lex.yy.c src/lexical.l && gcc src/yacc.tab.c src/lex.yy.c -o laplc -march=native -O2 -static

run:
	./laplc

run0:
	./laplc < input/0.lapl

run1:
	./laplc < input/1.lapl

run2:
	./laplc < input/2.lapl

run3:
	./laplc < input/3.lapl

run4:
	./laplc < input/4.lapl

run5:
	./laplc < input/5.lapl
	
