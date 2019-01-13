%{
	#include "y.tab.h"

	int LINE = 1;
	int COLUMN = 1;
%}

%%
"PROGRAM"			{ COLUMN += 7; return TOK_PROGRAM; }
"VAR"				{ COLUMN += 3; return TOK_VAR; }
"BEGIN"				{ COLUMN += 5; return TOK_BEGIN; }
"END"				{ COLUMN += 3; return TOK_END; }
"INTEGER"			{ COLUMN += 7; return TOK_INTEGER; }	
"DIV"				{ COLUMN += 3; return TOK_DIV; }
"READ"				{ COLUMN += 4; return TOK_READ; }
"WRITE"				{ COLUMN += 5; return TOK_WRITE; }
"FOR"				{ COLUMN += 3; return TOK_FOR; }
"DO"				{ COLUMN += 2; return TOK_DO; }
"TO"				{ COLUMN += 2; return TOK_TO; }
";"				{ COLUMN += 1; return ';'; }
":"				{ COLUMN += 1; return ':'; }	
","				{ COLUMN += 1; return ','; }
":="				{ COLUMN += 2; return TOK_ATTR; }
"+"				{ COLUMN += 1; return '+'; }
"-"				{ COLUMN += 1; return '-'; }
"*"				{ COLUMN += 1; return '*'; }
"("				{ COLUMN += 1; return '('; }
")"				{ COLUMN += 1; return ')'; }

0|[1-9][0-9]*			{ yylval.val = atoi(yytext); return TOK_NUMBER; }
[a-zA-Z][a-zA-Z0-9]* 		{ yylval.sir = new char[strlen(yytext)+1]; 					strcpy(yylval.sir,yytext); return TOK_VARIABLE;}
[ ]				{ COLUMN++; }
\r\n				{ LINE++; COLUMN=1; }
\n				{ LINE++; COLUMN=1; }
.				{ COLUMN++; return TOK_ERROR; }
%%
