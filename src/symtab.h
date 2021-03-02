/* Maximum number of symbols we can have */
#define SYMBOLTABLESIZE 100

/*
    An entry in the symbol table has a name, a pointer
    to a function, and a numeric value.
*/

struct symtab
{
    char *name;
    float (*funcptr)();
    float value;
} symtab[SYMBOLTABLESIZE];

struct symtab *symlook();