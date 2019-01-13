%{
	#include <stdio.h>
     	#include <string.h>

	int yylex();
	int yyerror(const char *msg);

    	int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%code requires {
typedef struct punct { int x,y,z; } PUNCT;
}

%union { char* sir; int val; }

%token TOK_PROGRAM TOK_VAR TOK_BEGIN TOK_END TOK_INTEGER TOK_DIV TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_ID TOK_INT TOK_LEFT TOK_RIGHT TOK_DECLARE TOK_PRINT TOK_ERROR TOK_ATTR
%token <val> TOK_NUMBER
%token <sir> TOK_VARIABLE



%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE




%%
prog: 
|
TOK_PROGRAM prog_name TOK_VAR dec_list TOK_BEGIN stmt_list TOK_END
|
error { EsteCorecta = 0; }
;
prog_name: TOK_VARIABLE
;
dec_list: dec
	|
	dec_list ';' dec
;
dec: id_list ':' type
;
type: TOK_INTEGER
;
id_list: TOK_VARIABLE
	|
	id_list ',' TOK_VARIABLE
;
stmt_list: stmt
	|
	stmt_list ';' stmt
;
stmt: assign
	|
	read
	|
	write
	|
	for
;
assign: TOK_VARIABLE TOK_ATTR exp
;
exp: term
	|
	exp '+' term
	|
	exp '-' term
;
term: factor
	|
	term '*' factor
	|
	term TOK_DIV factor
;
factor: TOK_VARIABLE
	|
	TOK_INT
	|
	'(' exp ')'
;
read: TOK_READ '(' id_list ')'
;
write: TOK_WRITE '(' id_list ')'
;
for: TOK_FOR index_exp TOK_DO body
;
index_exp: TOK_VARIABLE TOK_ATTR exp TOK_TO exp
;
body: stmt
	|
	TOK_BEGIN stmt_list TOK_END
;


%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	

       return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}

