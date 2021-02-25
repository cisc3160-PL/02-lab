%{ 
#include "calc.h"
#include <string.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/************************************************************************
* Defines a yacc grammar for a simple calculator using infix
* notation.  WHen executed, the calculator enters a loop in
* which it prints the prompt >>, reads a toplevel expression
* terminated by a newline, and prints its value.  Operators
* include +, -, *, and = (assignment). Note that all
* expressions return values, even assignment.  Parentheses
* can be used to override operator precedence and
* associativity rules. Based on zcalc by ruiz@capsl.udel.edu
************************************************************************/

int yylex();

%}
 
/*
  Th union directive specifies the collection of tpes our grammar
  deals with -- just doubles and pointers to symbol table entries.
*/

%union {
  double dval;
  struct symtab *symp;
  }

/*
  Declare the token types and any associated value types.  We made
  EQ a token in calc.l because otherwise '=' and '==' would clash.
*/


%token <symp> NAME
%token <dval> NUMBER
%token EQ

/* The folowing declarations specify the precidence and associativity
   of our operators. The operators -, +, * and / to be left
   associative, * and EQ to be right associative and UMINUS to be
   non-associative (since it is a unary operator). The '=' operator
   has the lowest precedence and UMINUS the highest.
*/

%right '='           /* lowest precedence */
%right EQ
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS     /* highest precedence */


/*
  Declare the type of expression to be a dval (double).
*/

%type <dval> expr

%%

/* 
  Here are our grammar rules.  a session is a sequence of lines.  A
  toplevel is just an expr (print its value followed by two
  newlines and the prompt >>) or a '? (print help) or a '.' (exit).
  An expr can be a number, name, the sum of two exprs, ...
 */

session: /* empty */
         |
          session toplevel '\n'
;

toplevel: expr     { printf("%g\n\n>> ", $1); }
          | '?'    { printHelp(); printf("\n>> "); }
          | '.'    { printf("Exiting 331 calc\n"); exit(1); }
 ;

expr:  NUMBER                  { $$ = $1; }
       | NAME                  { $$ = $1->value; }
       | NAME '=' expr         { $1->value = $3; $$ = $3; }
       | expr EQ expr      { $$ = $1 == $3; }
       | expr '+' expr         { $$ = $1 + $3; }
       | expr '-' expr         { $$ = $1 - $3; }
       | expr '*' expr         { $$ = $1 * $3; }
       | expr '/' expr         { $$ = $1 / $3; }
       | '-' expr %prec UMINUS { $$ = -$2; }
       | '(' expr ')'          { $$ = $2; }
;
%%

struct symtab *
symlook(s)
char *s;
{
   char *p;
   struct symtab *sp;

   /* given the name of a symbol, scan the symbol table and
      either return the entry with matching name or add it
      to the next free cell in the symbol table. */

   for(sp = symtab; sp < &symtab[SYMBOLTABLESIZE]; sp++) {

     /* If the symbol table entry has a name and its equal
	to the one we are looking for, return this entry */
     if (sp->name && !strcmp(sp->name, s))
       return sp;

     /* If the name is empty then this entry is free, so the
	symbol must not be in the table and we can add it here
        and return this entry. */
     if (!sp->name) {
       sp->name = strdup(s);
       return sp;
       }
   }

   /* We searched the entire symbol table and neither found
      the symbol or an unused entry.  So the table must be
      full.  Sigh. */
   yyerror("The symbol table is full, sorry...\n");
   exit(1);
}



void printHelp() 
{ /* print calculator help and return */
  printf("Enter an expression in infix notation followed by a newline.\n");
  printf("Operators include +, -, * and =.  Defined functions include\n");
  printf("sqrt, exp and log.  You can assign a variable using the =\n");
  printf("operator. Type . to exit.  Syntax errors will terminate the\n");
  printf("program, so be careful.\n");
}


/* If error prints error and Do not accept to signify bad syntax in
   program */

void yyerror(char *msg)	/* yacc error function */
{
  printf("%s \n" , msg);  
}

int main()
{ /* print herald and call parser */
  printf("331 Calculator\n(type ? for help and . to exit)\n\n>> ");
  yyparse();
}