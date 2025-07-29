#include <stdio.h>

extern int yyparse();

int main() {
    printf("Mini Compiler Started\n");
    yyparse();
    return 0;
}
