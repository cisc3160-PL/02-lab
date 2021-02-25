/* C declarations */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>

    void yyerror(char *s);
    int yylex();

    int symbols[52];
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int val);
%}

/* Yacc definitions */
%union { int num; char id; }
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%

/* Descriptions of expected inputs -> corresponding actions in C */
line    : assignment ';'            { ; }
        | exit_command ';'          { exit(EXIT_SUCCESS); }
        | print exp ';'             { printf("Printing %d\n", $2); }
        | line assignment ';'       { ; }
        | line print exp ';'        { printf("Printing %d\n", $3); }
        | line exit_command ';'     { exit(EXIT_SUCCESS); }
        ;

assignment : identifier '=' exp     { updateSymbolVal($1, $3); }

exp     : term                      { $$ = $1; }
        | exp '+' term              { $$ = $1 + $3; }
        | exp '-' term              { $$ = $1 - $3; }
        | exp '*' term              { $$ = $1 * $3; }
        | exp '/' term              { $$ = $1 / $3; }
        ;

term    : number                    { $$ = $1; }
        | identifier                { $$ = symbolVal($1); }
        ;

%%

/* C auxiliary code for additional processing */

int computeSymbolIndex(char token)
{
    int idx = -1;
    if(islower(token)) idx = token - 'a' + 26;
    else if(isupper(token)) idx = token - 'A';
    return idx;
}

/* Returns the value of a given symbol */
int symbolVal(char symbol)
{
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

/* Updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

int main(void)
{
    /* init symbol table */
    for(int i = 0; i < 52; i++)
    {
        symbols[i] = 0;
    }

    return yyparse();
}

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}