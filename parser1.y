/* parser.y */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int symbol_table[100];
int get_variable_index(const char* name);
void yyerror(const char* s);
int yylex(void);

int condition_result = 0;
int execute_flag = 1;
%}

%union {
    int ival;
    char* sval;
}

%nonassoc IFX
%nonassoc ELSE

%token <ival> NUMBER
%token <sval> ID
%token <sval> STRING
%token TYPE PRINTF SCANF IF ELSE FOR
%token EQ NEQ LE GE

%type <ival> expression condition assignment statement declaration for_init

%start program

%%

program:
    statements
    ;

statements:
    statements statement
    | /* empty */
    ;

statement:
    declaration ';'
  | assignment ';'
  | PRINTF '(' STRING ',' ID ')' ';' {
        if (execute_flag) {
            int idx = get_variable_index($5);
            printf($3, symbol_table[idx]);
        }
        free($3); free($5);
    }
   | SCANF '(' STRING ',' ID ')' ';' {
        if (execute_flag) {
            int idx = get_variable_index($5);
            scanf($3, &symbol_table[idx]);
        }
        free($3); free($5);
    }

  | IF '(' condition ')' block %prec IFX {
        int prev_flag = execute_flag;
        execute_flag = condition_result;
        if (execute_flag) {
            // Block executed inside
        }
        execute_flag = prev_flag;
    }
  | IF '(' condition ')' block ELSE block {
        int prev_flag = execute_flag;
        if (condition_result) {
            execute_flag = 1;
            // true block executed
        } else {
            execute_flag = 1;
            // false block executed
        }
        execute_flag = prev_flag;
    }
  | FOR '(' for_init ';' condition ';' assignment ')' block {
        int prev_flag = execute_flag;
        for ($3; $5; $7) {
            if (execute_flag) {
                // block is already parsed
            }
        }
        execute_flag = prev_flag;
    }
  ;

for_init:
    declaration
  | assignment
  ;

block:
    '{' statements '}'
  | statement
  ;

declaration:
    TYPE ID '=' expression {
        if (execute_flag) {
            int idx = get_variable_index($2);
            symbol_table[idx] = $4;
            printf("Declared %s = %d\n", $2, $4);
        }
        free($2);
        $$ = 0;
    }
  ;

assignment:
    ID '=' expression {
        if (execute_flag) {
            int idx = get_variable_index($1);
            symbol_table[idx] = $3;
            printf("Assigned %s = %d\n", $1, $3);
        }
        free($1);
        $$ = 0;
    }
  ;

condition:
    expression EQ expression  { condition_result = ($1 == $3); $$ = condition_result; }
  | expression NEQ expression { condition_result = ($1 != $3); $$ = condition_result; }
  | expression '<' expression { condition_result = ($1 < $3);  $$ = condition_result; }
  | expression '>' expression { condition_result = ($1 > $3);  $$ = condition_result; }
  | expression LE expression  { condition_result = ($1 <= $3); $$ = condition_result; }
  | expression GE expression  { condition_result = ($1 >= $3); $$ = condition_result; }
  ;

expression:
      NUMBER { $$ = $1; }
    | ID     {
        int idx = get_variable_index($1);
        $$ = symbol_table[idx];
        free($1);
    }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { $$ = $3 ? $1 / $3 : 0; }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int get_variable_index(const char* name) {
    return name[0] % 100;
}
