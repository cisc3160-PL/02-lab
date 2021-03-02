%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"

extern void yyerror(char *s);
extern int yylex();

%}

%union {
    float fval;
    struct symtab *symp;
}

%token <symp> IDENTIFIER
%token <fval> NUMBER

/* Precedence */
%right '='
%left '+' '-'
%left '*' '/'

%type <fval> num_expression

%%

session
    : /* empty */
    | session toplevel '\n'
    ;

toplevel
    : num_expression                    { printf("%g\n\n>> ", $1); }
    | '.'                               { printf("Exiting...\n"); exit(1); }                               
    ;

num_expression
    : NUMBER                            { $$ = $1; }
    | IDENTIFIER                        { $$ = $1->value; }
    | IDENTIFIER '=' num_expression     { $1->value = $3; $$ = $3; }
    | num_expression '+' num_expression { $$ = $1 + $3; }
    | num_expression '-' num_expression { $$ = $1 - $3; }
    | num_expression '*' num_expression { $$ = $1 * $3; }
    | num_expression '/' num_expression { $$ = $1 / $3; }
    | '(' num_expression ')'            { $$ = $2; }
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
    printf("Basic calculator (type . to exit)\nSupports +, -, *, /, () and variable assignment\n\n>> ");
    return yyparse();
}

void yyerror(char *s)
{
    printf("%s\n", s);
}