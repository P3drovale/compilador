#include <stdio.h>

extern int yyparse();
extern FILE* yyin;
FILE* output_file;

int main(int argc, char** argv) {
    if (argc != 3) {
        fprintf(stderr, "Uso: %s <archivo_entrada> <archivo_salida>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("No se pudo abrir el archivo de entrada");
        return 1;
    }

    output_file = fopen(argv[2], "w");
    if (!output_file) {
        perror("No se pudo crear el archivo de salida");
        fclose(yyin);
        return 1;
    }

    yyparse();

    fclose(yyin);
    fclose(output_file);
    return 0;
}
