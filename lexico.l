%option noyywrap

%{
    #include <stdbool.h>
    #include <stdio.h>
    #include <string.h>

    int column = 1;
    int columnStartComment = 1;
    int lineStartComment = 1;
    bool isFirstLine = true;

    void printString(int len, char string[]){
        printf("(");
        for(int i = 1; i < len-1; i++){
            printf("%c", string[i]);
        }
        printf(")");
    }
%}

%x multLineComment

%%

"/*"            		                {columnStartComment = column + 2; lineStartComment = yylineno; BEGIN(multLineComment);}
    <multLineComment>"/*"               {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("warning:%d:%d: '/*' within block comment", yylineno, column); column+=2;}
    <multLineComment><<EOF>>            {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("error:lexical:%d:%d: unterminated comment", lineStartComment, columnStartComment); return 0;}
    <multLineComment>"*/" 	            {column+=2;BEGIN(INITIAL);}
    <multLineComment>"/*/" 	            {column+=3;BEGIN(INITIAL);}
    <multLineComment>"//"               {column+=2;}
    <multLineComment>\n                 {column = 1; yylineno++;}
    <multLineComment>[^"/*""*/""//"\n]+ {column+=strlen(yytext);}
    <multLineComment>.                {column++;}    

"//".*\n    {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("comment %s", yytext); column = 1; yylineno++;}

[\"\'][^\"\'][\"\']                 {(isFirstLine)?(isFirstLine=false):(printf("\n")); printf("CHARACTER"); printString(3, yytext); column+=3;}
[\"\']\\[abfnrtv0\\\'\"\?][\"\']    {(isFirstLine)?(isFirstLine=false):(printf("\n")); printf("CHARACTER"); printString(4, yytext); column+=4;}
[\"\'][^\"\']*[\"\']                {(isFirstLine)?(isFirstLine=false):(printf("\n")); printf("STRING"); printString(strlen(yytext), yytext); column+=strlen(yytext);}

void        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("VOID"); column+=4;}
int         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("INT"); column+=3;}
char        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("CHAR"); column+=4;}
return      {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("RETURN"); column+=6;}
break       {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("BREAK"); column+=5;}
switch      {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("SWITCH"); column+=6;}
case        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("CASE"); column+=4;}
default     {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("DEFAULT"); column+=7;}
do          {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("DO"); column+=2;}
while       {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("WHILE"); column+=5;}
for         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("FOR"); column+=3;}
if          {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("IF"); column+=2;}
else        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("ELSE"); column+=4;}
typedef     {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("TYPEDEF"); column+=7;}
struct      {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("STRUCT"); column+=6;}
printf      {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("PRINTF"); column+=6;}
scanf       {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("SCANF"); column+=5;}
define      {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("DEFINE"); column+=6;}
"exit"      {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("EXIT"); column+=4;}

"+"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("PLUS"); column++;}
"-"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("MINUS"); column++;}
"*"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("MULTIPLY"); column++;}
"/"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("DIV"); column++;}
"%"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("REMAINDER"); column++;}
"++"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("INC"); column+=2;}
"--"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("DEC"); column+=2;}

"&"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("BITWISE_AND"); column++;}
"|"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("BITWISE_OR"); column++;}
"~"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("BITWISE_NOT"); column++;}
"^"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("BITWISE_XOR"); column++;}

"!"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("NOT"); column++;}
"&&"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("LOGICAL_AND"); column+=2;}
"||"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("LOGICAL_OR"); column+=2;}

"=="        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("EQUAL"); column+=2;}
"!="        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("NOT_EQUAL"); column+=2;}
"<"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("LESS_THAN"); column++;}
">"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("GREATER_THAN"); column++;}
"<="        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("LESS_EQUAL"); column+=2;}
">="        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("GREATER_EQUAL"); column+=2;}
">>"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("R_SHIFT"); column+=2;}
"<<"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("L_SHIFT"); column+=2;}
"="         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("ASSIGN"); column++;}
"+="        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("ADD_ASSIGN"); column+=2;}
"-="        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("MINUS_ASSIGN"); column+=2;}

";"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("SEMICOLON"); column++;}
","         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("COMMA"); column++;}
":"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("COLON"); column++;}
"("         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("L_PAREN"); column++;}
")"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("R_PAREN"); column++;}
"{"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("L_CURLY_BRACKET"); column++;}
"}"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("R_CURLY_BRACKET"); column++;}
"["         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("L_SQUARE_BRACKET"); column++;}
"]"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("R_SQUARE_BRACKET"); column++;}
"?"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("TERNARY_CONDITIONAL"); column++;}
"#"         {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("NUMBER_SIGN"); column++;}
"->"        {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("POINTER"); column+=2;}

0[1-7][0-7]*            {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("NUM_OCTAL(%s)", yytext); column+=strlen(yytext);}
0[xX][0-9a-fA-F]+       {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("NUM_HEXA(%s)", yytext); column+=strlen(yytext);}
[0-9]+                  {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("NUM_INTEGER(%s)", yytext); column+=strlen(yytext);}

[a-zA-Z_][a-zA-Z0-9_]*  {if(strlen(yytext) < 256){
                            (isFirstLine)?(isFirstLine=false):(printf("\n")); 
                            printf("IDENTIFIER(%s)", yytext);
                            column+=strlen(yytext);
                            }
                        else{
                            (isFirstLine)?(isFirstLine=false):(printf("\n")); 
                            printf("error:lexical:%d:%d: identifier too long", yylineno, column);
                            column+=strlen(yytext);
                            }
                        }

" "          {column++;}
\r?\n        {column = 1; yylineno++;}
.            {(isFirstLine)?(isFirstLine=false):(printf("\n"));  printf("error:lexical:%d:%d: %s", yylineno, column, yytext); column++;}

%%

int main (int argc , char ** argv)
{
    yylex();
    return 0;
}