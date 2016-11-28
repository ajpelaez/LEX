/*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
int nFechas=0;
int nTelefonos=0;
int nMatriculas=0;
int nCodigosPostales=0;
int nNIFs=0;
void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5);
%}

dia	(0[1-9])|([1-2][0-9])|(3[0-1])	
mes	(0[1-9])|(1[0-2])		
anio	([1-9]([0-9]{3}))

letra_matricula	[BCDFGHJKLMNÑPQRSTVWXYZ]		

%%
{dia}\/{mes}\/{anio}			{ nFechas++; }
[6-7]([0-9]{8})				{ nTelefonos++; }
([0-9]{4})[ \-]?({letra_matricula}{3})	{ nMatriculas++; }
[ ][0-9]{5}[ ]				{ nCodigosPostales++; }
([0-9]{8})[A-Z] 			{ nNIFs++; }

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
	escribir_datos(nFechas,nTelefonos,nMatriculas,nCodigosPostales,nNIFs);
	return 0;
}

void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5) {
	printf ("\nNum_fechas=%d\tNum_telefonos=%d\tNum_matriculas=%d\tNum_codigos_postales=%d\tNum_NIFs=%d\n", dato1,dato2,dato3,dato4,dato5);
}
