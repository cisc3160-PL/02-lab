scanner: lex.yy.o
	gcc scanner.c lex.yy.c -o scanner

lex.yy.o:
	lex scanner.l

run: scanner
	./scanner < config.in

clean:
	rm lex.yy.c scanner