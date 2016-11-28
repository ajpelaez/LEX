/*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
int nComentarios1=0;
int nComentarios2=0;
void escribir_datos (int dato1, int dato2);
%}


%%
\/\*(.|\n)*\*\/		{ printf(yytext); nComentarios2++; }
\/\/[^\n]*\n		{ printf(yytext); nComentarios1++; }


%%

/*----- Sección de Procedimientos --------*/
int main (int argc, char *argv[]) {
	if (argc == 2) {
	yyin = fopen (argv[1], "rt");	
	if (yyin == NULL) {
	printf ("El fichero %s no se puede abrir\n", argv[1]);
	exit (-1);
	}
	}
	else yyin = stdin;
	yylex ();
	escribir_datos(nComentarios1,nComentarios2);
	return 0;
}

void escribir_datos (int dato1, int dato2) {
	printf ("\nNum_comentarios1=%d\tNum_comentarios2=%d\n", dato1,dato2);
}
