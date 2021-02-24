%{
#include "y.tab.h"
#include "calc.h"
#include <math.h>

/************************************************************************
A lexical scanner to recognize numbers, symbols and the EQ
operator.  When a NUMBER is found, its value is set is set to the
appropriate float.  When a NAME is found, an entry in symbol table is
created (with initial value 0.0) and the token's value is a pointer to
this entry.  If a '==' sequence is seen, it is returned as a token
EQ.  Spaces and tabs are ignored. Any other characters, including
a newline, are passed on as their own tokens. Based on the zcalc
calculator by ruiz@capsl.udel.edu
************************************************************************/

%}

D     [0-9]
A     [a-zA-Z]
AD    [a-zA-Z0-9]

%%

({D}+|({D}*\.{D}+)([eE][-+]?{D}+)?) {yylval.dval = atof(yytext); return NUMBER;}

{A}{AD}*                            {struct symtab *sp = symlook(yytext); yylval.symp = sp; return NAME;}

==                                  {return EQ;}

[ \t]  ;

\n    |
.     return yytext[0];
%%