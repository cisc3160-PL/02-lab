/********************************************
* Yacc grammar for simple language
*********************************************/

/**** DECLARATIONS ****/

/* C declarations */
%{

#include "src/symtab.h"
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *s);
int yylex();

%}

/* Yacc definitions */

/*
    Union specifies collection of types our grammar deals with
*/
%union {
    double dval;
    struct symtab *sym;
}

/* Data types */
%token <sym> NAME
%token <dval> NUMBER

/* Precedence */
%right '='          /* lowest */
%right EQ
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS    /* highest */

%type <dval> expr

/**** RULES ****/
%%

session
    : /* empty */
    | session cursor '\n'
    ;

cursor
    : expr      { printf("%g\n>> ", $1); }
    ;

expr
    : NUMBER                { $$ = $1; }
    | NAME                  { $$ = $1->value; }
    | NAME '=' expr         { $1->value = $3; $$ = $3; }
    | expr EQ expr          { $$ = $1 == $3; }
    | expr '+' expr         { $$ = $1 + $3; }
    | expr '-' expr         { $$ = $1 - $3; }
    | expr '*' expr         { $$ = $1 * $3; }
    | expr '/' expr         {
                                if($3 == 0.0) yyerror("Can't divide by zero");
                                else $$ = $1 / $3;
                            }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')'          { $$ = $2; }
    ;

%%

/**** AUXILIARY C FOR PROCESSING ****/

/* Look up a symbol table entry, add if not present */
struct symtab *
symlook(s)
char *s;
{
    char *p;
    struct symtab *sp;

    for(sp = symtab; sp < &symtab[SYMBOLTABLESIZE]; sp++)
    {
        /* check if entry is already here */
        if(sp->name && !strcmp(sp->name, s)) return sp;

        /* check if free */
        if(!sp->name)
        {
            sp->name = strdup(s);
            return sp;
        }
    }
    yyerror("Symbol table has exceeded capacity.");
    exit(1);
}

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

int main()
{
    printf("Calculator\n>> ");
    yyparse();
}