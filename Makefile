kuiper: yacc lex
	gcc lex.yy.c y.tab.c -o kuiper

yacc: lang.y
	# -d will generate y.tab.h for lexer to use
	yacc -d lang.y

lex: lang.l
	# Generate lex.yy.c
	lex lang.l

clean:
	rm kuiper lex.yy.c y.tab.*