%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* output_file;

void yyerror(const char *s);
int yylex();
char* str_concat(const char* a, const char* b);
char* indent_block(const char* block);
%}

%union {
    int num;
    char* str;
}

%token <str> STRING IDENTIFIER COMMENT
%token <num> NUMBER
%token IF THEN ELSE END FOR TO STEP PRINT WHILE EXP
%token EQUALS PLUS MINUS TIMES DIVIDE NEWLINE
%token EQ NEQ LT LE GT GE AND OR NOT

%left OR
%left AND
%nonassoc EQ NEQ LT LE GT GE
%right NOT
%left PLUS MINUS
%left TIMES DIVIDE
%left '(' ')'

%type <str> expression line lines

%%

program:
    lines {
        fprintf(output_file, "%s", $1);
        free($1);
    }
;

lines:
      /* vacío */ { $$ = strdup(""); }
    | lines line {
        $$ = str_concat($1, $2);
        free($1); free($2);
    }
;

line:
    COMMENT NEWLINE {
        int len = strlen($1) + 4;
        $$ = (char*) malloc(len);
        snprintf($$, len, "#%s\n", $1);
        free($1);
    }
    | IDENTIFIER EQUALS expression NEWLINE {
        int len = strlen($1) + strlen($3) + 10;
        $$ = (char*) malloc(len);
        snprintf($$, len, "%s = %s\n", $1, $3);
        free($1); free($3);
    }
    | PRINT expression NEWLINE {
        int len = strlen($2) + 15;
        $$ = (char*) malloc(len);
        snprintf($$, len, "print(%s)\n", $2);
        free($2);
    }
    | FOR IDENTIFIER EQUALS expression TO expression STEP expression NEWLINE lines END NEWLINE {
        char header[256];
        snprintf(header, sizeof(header), "for %s in range(%s, %s + 1, %s):\n", $2, $4, $6, $8);
        char* body = indent_block($10);
        $$ = str_concat(header, body);
        free($2); free($4); free($6); free($8); free($10); free(body);
    }
    | WHILE expression NEWLINE lines END NEWLINE {
        char header[256];
        snprintf(header, sizeof(header), "while %s:\n", $2);
        char* body = indent_block($4);
        $$ = str_concat(header, body);
        free($2); free($4); free(body);
    }
    | IF expression THEN NEWLINE lines END NEWLINE {
        char header[256];
        snprintf(header, sizeof(header), "if %s:\n", $2);
        char* body = indent_block($5);
        $$ = str_concat(header, body);
        free($2); free($5); free(body);
    }
    | IF expression THEN NEWLINE lines ELSE NEWLINE lines END NEWLINE {
        char header[256];
        snprintf(header, sizeof(header), "if %s:\n", $2);
        char* if_body = indent_block($5);
        char* else_body = indent_block($8);
        char* temp = str_concat(header, if_body);
        char* else_header = strdup("else:\n");
        char* temp2 = str_concat(temp, else_header);
        $$ = str_concat(temp2, else_body);
        free($2); free($5); free($8);
        free(if_body); free(else_body);
        free(temp); free(temp2); free(else_header);
    }
    | error NEWLINE {
        yyerror("Error en la línea. Continuando...");
        $$ = strdup("");
        yyerrok;
    }
;

expression:
    expression PLUS expression { $$ = str_concat($1, " + "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression MINUS expression { $$ = str_concat($1, " - "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression TIMES expression { $$ = str_concat($1, " * "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression DIVIDE expression { $$ = str_concat($1, " / "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression EQ expression { $$ = str_concat($1, " == "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression NEQ expression { $$ = str_concat($1, " != "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression LT expression { $$ = str_concat($1, " < "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression LE expression { $$ = str_concat($1, " <= "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression GT expression { $$ = str_concat($1, " > "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression GE expression { $$ = str_concat($1, " >= "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression AND expression { $$ = str_concat($1, " and "); $$ = str_concat($$, $3); free($1); free($3); }
    | expression OR expression { $$ = str_concat($1, " or "); $$ = str_concat($$, $3); free($1); free($3); }
    | NOT expression {
        int len = strlen($2) + 6;
        $$ = (char*) malloc(len);
        snprintf($$, len, "not %s", $2);
        free($2);
    }
    | '(' expression ')' {
        int len = strlen($2) + 3;
        $$ = (char*) malloc(len);
        snprintf($$, len, "(%s)", $2);
        free($2);
    }
    | EXP '(' expression ',' expression ')' {
        int len = strlen($3) + strlen($5) + 6;
        $$ = (char*) malloc(len);
        snprintf($$, len, "%s ** %s", $3, $5);
        free($3); free($5);
    }
    | NUMBER {
        char buffer[32];
        snprintf(buffer, sizeof(buffer), "%d", $1);
        $$ = strdup(buffer);
    }
    | IDENTIFIER { $$ = strdup($1); }
    | STRING {
        int len = strlen($1) + 3;
        $$ = (char*) malloc(len);
        snprintf($$, len, "\"%s\"", $1);
        free($1);
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}

char* str_concat(const char* a, const char* b) {
    char* result = (char*) malloc(strlen(a) + strlen(b) + 1);
    strcpy(result, a);
    strcat(result, b);
    return result;
}

char* indent_block(const char* block) {
    char* result = malloc(strlen(block) * 2 + 1);
    result[0] = '\0';
    const char* p = block;
    while (*p) {
        strcat(result, "    ");
        while (*p && *p != '\n') {
            strncat(result, p, 1);
            p++;
        }
        if (*p == '\n') {
            strncat(result, p, 1);
            p++;
        }
    }
    return result;
}
