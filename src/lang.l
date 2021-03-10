%{

#include "y.tab.h"
#include "symtab.h"

extern int yylex();

void invalidToken();

%}

/* Digits */
D   [0-9]
/* Alphabet w/ underscore */
A   [a-zA-Z_]
/* Exponents */
E   [Ee][-+]?{D}+

whitespace  [ \t\r\v\f]
newline     \n

%%

"print"         { return keyword_print; }
"println"       { return keyword_println; }

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

"="             { return '='; }
"("             { return '('; }
")"             { return ')'; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"<"             { return '<'; }
">"             { return '>'; }
"<="            { return op_le; }
">="            { return op_ge; }
"=="            { return op_eq; }
"!="            { return op_neq; }

{newline}       { yylineno++; return '\n'; }
{whitespace}    ;
.               { invalidToken(); }

%%

int yywrap()
{
    return 1;
}

void invalidToken()
{
    printf("Error on line %d:\n Invalid token %s\n", yylineno, yytext);
    exit(0);
}