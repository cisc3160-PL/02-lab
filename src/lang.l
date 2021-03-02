/* Digits */
D   [0-9]
/* Alphabet w/ underscore */
A   [a-zA-Z_]
/* Exponents */
E   [Ee][-+]?{D}+

%{

#include "y.tab.h"
#include "symtab.h"

extern void yyerror(char *s);
extern int yylex();

%}

%%

"print"     { return keyword_print; }
"println"   { return keyword_println; }

{A}({A}|{D})* {
    struct symtab *sp = symlook(yytext);
    yylval.symp = sp;
    return IDENTIFIER;
} /* Could be variable or function (_prvFunc, pubFunc) */

({D}+|({D}*\.{D}+)({E})?) {
    yylval.fval = atof(yytext);
    return NUMBER;
} /* Integers or floating point */

"=" { return '='; }
"(" { return '('; }
")" { return ')'; }
"+" { return '+'; }
"*" { return '*'; }
"/" { return '/'; }

[ \t]       ;                       /* Ignore tabs and spaces */

\n          |
.           { return yytext[0]; }   /* Return nextline and everything else as tokens */

%%

int yywrap()
{
    return 1;
}