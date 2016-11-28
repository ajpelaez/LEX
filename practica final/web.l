/*----- Sección de Declaraciones --------------*/

%{
#include <stdio.h>
#include <string.h>
#include <iostream>
using namespace std;

char directorio_noticia[500];
char contenido_noticia[2000] = "";
bool primer_contenido = true;




int system(const char *command);
%}

%START	titular descargar_imagen titular_buscar_contenido titular_contenido
frase	([0-9]|[A-Z]|[a-z]|" "|\,|\.|á|é|í|ó|ú|ñ|"-"|"/ "|" /"|"<strong>"|"</strong>")*
frase2	([0-9]|[A-Z]|[a-z]|" "|\,|\.|á|é|í|ó|ú|ñ)*
barra_en_frase "/ "|" /"
html_esp	<[^<>]*>
titulo	" "class\=\"antetitulo\"\>
inicio_noticia	"<p>"
fin_noticia "</p>"


video "<a href=\"".*"videos.marca.com".*
img_png	\"[^"]*".png"\"
img_jpg	\"[^"]*".jpg"\"

%%

{titulo}	{BEGIN titular;}

<titular>{frase}	{
	//Sustituyo espacios por _ para que funcione bien el mkdir
	//Y quito los <strong> y </strong>
    	for(int i=0; yytext[i] != '\0'; i++){
    		if(yytext[i] == ' ')
    			yytext[i] = '_';
		if((yytext[i] == '<') && (yytext[i+1]=='/'))
			i=i+8;
		if(yytext[i] == '<')
			i=i+7;
	}		

	char buff[1000];
	char * comando ="cd imgs && mkdir ";
	strcpy(buff,comando);
	strcat(buff,yytext);
	strcpy(directorio_noticia,yytext);
	int get=system (buff);
	BEGIN descargar_imagen; 

}

<descargar_imagen>{video}	{ 
	char buff[1000];
	char * comando1 ="cd imgs/";
	char * comando2 =" && wget ";
	strcpy(buff,comando1);
	strcat(buff,directorio_noticia);
	strcat(buff,comando2);
	strcat(buff,"http://world.honda.com/shared/img/sp/img_play.png");
	int get=system (buff); 
	BEGIN titular_buscar_contenido;
	}

<descargar_imagen>{img_png}|{img_jpg}	{ 
	char buff[1000];
	char * comando1 ="cd imgs/";
	char * comando2 =" && wget ";
	strcpy(buff,comando1);
	strcat(buff,directorio_noticia);
	strcat(buff,comando2);
	strcat(buff,yytext);
	int get=system (buff); 
	BEGIN titular_buscar_contenido;
	}

<titular_buscar_contenido>{inicio_noticia}	{ BEGIN titular_contenido; }

<titular_contenido>{fin_noticia}	{ 
	char buff[2000];
	char * comando1 ="cd imgs/";
	char * comando2 =" && echo ";
	char * comando3 =" > noticia.txt";
	strcpy(buff,comando1);
	strcat(buff,directorio_noticia);
	strcat(buff,comando2);
	strcat(buff,contenido_noticia);
	strcat(buff,comando3);
	int get=system (buff);
	primer_contenido=true;
	BEGIN 0;
}

<titular_contenido>{html_esp} {}
	
<titular_contenido>{frase2}	{
	if (primer_contenido){
	strcpy(contenido_noticia,yytext);
	primer_contenido=false;
	}
	else strcat(contenido_noticia,yytext);
}
	


{img_png}|{img_jpg}	{ 
	char buff[1000];
	char * comando ="cd imgs/marca && wget ";
	strcpy(buff,comando);
	strcat(buff,yytext);
	int get=system (buff); 

	}




.	{}



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
	

	int get=system ("mkdir imgs");
	get=system("cd imgs && mkdir marca");

	yylex ();

	return 0;
}


