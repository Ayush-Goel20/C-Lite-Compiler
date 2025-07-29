%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"int"           { return TYPE; }
"if"            { return IF; }
"else"          { return ELSE; }
"printf"        { return PRINTF; }
"scanf"         { return SCANF; }

"=="            { return EQ; }
"!="            { return NEQ; }
"<="            { return LE; }
">="            { return GE; }

[0-9]+          { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.sval = strdup(yytext); return ID; }
\"[^\"]*\"      { yylval.sval = strdup(yytext); return STRING; }

"="             { return '='; }
"<"             { return '<'; }
">"             { return '>'; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
";"             { return ';'; }

[ \t\r\n]+      { /* skip whitespace */ }
.               { return yytext[0]; }

%%
