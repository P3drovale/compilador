%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[ \t]+                  ;
\n                      { return NEWLINE; }

"if"                    { return IF; }
"then"                  { return THEN; }
"else"                  { return ELSE; }
"end"                   { return END; }
"for"                   { return FOR; }
"to"                    { return TO; }
"step"                  { return STEP; }
"print"                 { return PRINT; }
"and"                   { return AND; }
"or"                    { return OR; }
"not"                   { return NOT; }
"while"                 { return WHILE; }
"exp"                   { return EXP; }

"=="                    { return EQ; }
"!="                    { return NEQ; }
"<="                    { return LE; }
">="                    { return GE; }
"<"                     { return LT; }
">"                     { return GT; }

\"([^\"\n]|\\.)*\" {
    yylval.str = strdup(yytext + 1);
    yylval.str[strlen(yylval.str) - 1] = '\0';
    return STRING;
}

[0-9]+                  { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return IDENTIFIER; }

"="                     { return EQUALS; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return TIMES; }
"/"                     { return DIVIDE; }

"("                     { return '('; }
")"                     { return ')'; }
","                     { return ','; }

"!"[^\n]* {
    yylval.str = strdup(yytext + 1);
    return COMMENT;
}

"#".*                   ;  // Python-style comments, ignorar

. {
    fprintf(stderr, "Caracter desconocido ignorado: %s\n", yytext);
}

%%

int yywrap() { return 1; }
