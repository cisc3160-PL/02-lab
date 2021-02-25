#define SYMBOLTABLESIZE 50 /* Max number of symbols we can have */

/*
    An entry in the symbol table has a name, pointer to function, 
    and a numeric value
*/

struct symtab
{
    char *name;
    double (*fnptr)();
    double value;
} symtab[SYMBOLTABLESIZE];

struct symtab *symlook();