calc: yacc lex
	gcc lex.yy.c y.tab.c -o calc

yacc:
	# -d will generate y.tab.h for lexer to use
	yacc -d calc.y

lex:
	# Generate lex.yy.c
	lex calc.l

clean:
	rm calc lex.yy.c y.tab.*