%{
    #include <stdio.h>
    #include <string.h>
    int line = 0 ;
    int indent;

%}

ID      [a-zA-Z][a-zA-Z0-9]*
%%
"bool"|"break"|"case"|"char"|"class"|"const"|"cout"|"double"|"endl"|"false"|"float"|"for"|"if"|"if else"|"else"|"include"|"int"|"long"|"namespace"|"new"|"not"|"NULL"|"return"|"string"|"true"|"typename"|"using"|"void"|"while"    //do nothing erase the keywords       
"//".*                                      //printf("::comments::%s\n",yytext);  // after // do nothing until next line
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]         //printf("::comments::\n");           //from /* to */ do nothing
{ID}       {printf("Line: %d  Identifer(%s)\n",line,yytext);
            indent++;
            }//identifer ++
\n         line++;//line ++
.           //printf("%s",yytext);//anything else then keyword, identifers :: erase them from print out
%%

int yywrap(){
    return 1;
}
int main(void) {
    yyin = fopen("abc.cpp", "r");
    yylex();
    printf("The total line of the cpp file is:      %d\n",line);
    printf("The total identifer of the cpp file is: %d\n",indent);
    printf("Identifer list:");
    for(int i = 0;i < idcount;i++){
        printf("%s \t:",list_id[idcount]);
    }
    fclose(yyin);
    return 0;

}

