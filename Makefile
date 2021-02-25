lang: yacc lex
	gcc lex.yy.c y.tab.c -o lang -ly -ll -lm

yacc:
	yacc -d src/lang.y

lex:
	lex src/lang.l

clean:
	rm lang lex.yy.c y.tab.*