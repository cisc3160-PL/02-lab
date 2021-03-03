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

\"(\\.|[^"\\])*\" {
    yytext++; // Remove beginning quote
    yytext[strlen(yytext) - 1] = 0; // Remove end quote
    yylval.strval = yytext;
    return tSTRING;
} /* String */

{A}({A}|{D})* {
    struct symtab *sp = symlook(yytext);
    yylval.symp = sp;
    return tIDENTIFIER;
} /* Could be variable or function (_prvFunc, pubFunc) */

({D}+|({D}*\.{D}+)({E})?) {
    yylval.fval = atof(yytext);
    return tNUMBER;
} /* Integers or floating point */

"=" { return '='; }
"(" { return '('; }
")" { return ')'; }
"+" { return '+'; }
"*" { return '*'; }
"/" { return '/'; }

[ \t\n]     |       /* Ignore tabs, newlines and spaces */
.           ;       /* Ignore everything else */

%%

int yywrap()
{
    return 1;
}