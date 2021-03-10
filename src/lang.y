%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"

extern void yyerror(const char *s);
extern int yylex();
extern char *yytext;
extern int yylineno;

%}

%define parse.lac full
%define parse.error verbose

%union {
    float fval;
    char *strval;
    struct symtab *symp;
}

%token
    keyword_print
    keyword_println
    op_le
    op_ge
    op_eq
    op_neq

%token <symp> tIDENTIFIER
%token <fval> tNUMBER
%token <strval> tSTRING

/* Precedence */
%right '='
%nonassoc op_eq op_neq
%left '<' '>' op_le op_ge
%left '+' '-'
%left '*' '/'

%type <fval> num_expr
%type <strval> io_expr

%start lines

%%

lines
    : line
    | lines line
    ;

line
    : '\n'
    | expr
    | error '\n'                    { yyerrok; }
    ;

expr
    : io_expr
    | num_expr
    ;

io_expr
    : keyword_print tSTRING         { printf("%s", $2); }
    | keyword_println tSTRING       { printf("%s\n", $2); }
    | keyword_print num_expr        { printf("%g", $2); }
    | keyword_println num_expr      { printf("%g\n", $2); }
    ;

num_expr
    : tNUMBER                       { $$ = $1; }
    | tIDENTIFIER                   { $$ = $1->value; }
    | tIDENTIFIER '=' num_expr      { $1->value = $3; $$ = $3; }
    | num_expr '+' num_expr         { $$ = $1 + $3; }
    | num_expr '-' num_expr         { $$ = $1 - $3; }
    | num_expr '*' num_expr         { $$ = $1 * $3; }
    | num_expr '/' num_expr         { $$ = $1 / $3; }
    | '(' num_expr ')'              { $$ = $2; }
    | num_expr '<' num_expr         { $$ = ($1 < $3) ? 1 : 0; }
    | num_expr '>' num_expr         { $$ = ($1 > $3) ? 1 : 0; }
    | num_expr op_le num_expr       { $$ = ($1 <= $3) ? 1 : 0; }
    | num_expr op_ge num_expr       { $$ = ($1 >= $3) ? 1 : 0; }
    | num_expr op_eq num_expr       { $$ = ($1 == $3) ? 1 : 0; }
    | num_expr op_neq num_expr      { $$ = ($1 != $3) ? 1 : 0; }
    ;

%%

struct symtab *symlook(char *s)
{
    char *p;
    struct symtab *sp;

    /*
        Given the name of a symbol, scan the symbol table and
        either return the entry with matching name or add it
        to the next free cell in the symbol table
    */
    for(sp = symtab; sp < &symtab[SYMBOLTABLESIZE]; sp++)
    {
        /*
            If the symbol table entry has a name and is equal
            to the one we're looking for, return this entry
        */
        if(sp->name && !strcmp(sp->name, s)) return sp;

        /*
            If the name is empty then this entry is free, so
            the symbol must not be in the table and we can add
            it here and return this entry
        */
        if(!sp->name)
        {
            sp->name = strdup(s);
            return sp;
        }
    }

    /*
        If the entire symbol table does not contain the symbol or
        an available entry, the table must be full
    */
    yyerror("The symbol table is full. Exiting program...\n");
    exit(1);
}

int main()
{
    return yyparse();
}

void yyerror(const char *s)
{
    fprintf(stderr, "\nError on line %d:\n %s\n", yylineno, s);
    exit(0);
}