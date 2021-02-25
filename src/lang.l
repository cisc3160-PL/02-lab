/********************************************
* Lexer for simple language
*********************************************/

/**** DECLARATIONS ****/

/* C declarations */
%{

#include "y.tab.h"
#include "src/symtab.h"
#include <math.h>

%}

/* Lex definitions */
D   [0-9]
A   [a-zA-Z]
AD  [a-zA-Z0-9]

/**** RULES ****/
%%

({D}+|({D}*\.{D}+)([eE][-+]?{D}+)?) {
        yylval.dval = atof(yytext);
        return NUMBER;
    }

{A}{AD}* {
        struct symtab *sp = symlook(yytext);
        yylval.sym = sp;
        return NAME;
    }

==      { return EQ; }

[ \t]   ;

\n      |
.       return yytext[0];

%%

/**** AUXILIARY C FOR PROCESSING ****/