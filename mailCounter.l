/*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
int nc=0;
int nw=0;
void escribir_datos (int dato1, int dato2);
%}


%%
[a-z|A-Z|0-9|\-|_|\.]+@[a-z|A-Z|0-9|\-]+\.[a-z]+		{ nc++; }
(http:\/\/|https:\/\/|www\.).+\..+					{ nw++; }

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
	escribir_datos(nc,nw);
	return 0;
}

void escribir_datos (int dato1, int dato2) {
	printf ("\nNum_correos=%d\tNum_webs=%d\n", dato1,dato2);
}
