/***************************************************************************//**
Binghui Liu
006285600
09/30/2020
Purpose: CSE4600 Shell programing mini OS
*******************************************************************************/
//includes
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

//Function Declarations for builtin shell commands:
int lsh_cd(char **args);
int lsh_help(char **args);
int stop(char **args);
int setshellname(char **args);
int setterminator(char **args);
int newname(char **args);
int listnewnames(char **args);
int savenewnames(char **args);
int readnewnames(char **args);

//global variable 
char* shellname = "myshell";
char* terminator = ">";
char *newnames[10]; //empty array waiting for input
char *oldnames[10];//empty array waiting for input
int lsh_num_newnames = 0;

//List of builtin commands, followed by their corresponding functions.

char *builtin_str[] = {
  "cd",
  "help",
  "stop",
  "setshellname",
  "setterminator",
  "newname",
  "listnewnames",
  "savenewnames",
  "readnewnames"
};

int (*builtin_func[]) (char **) = {
  &lsh_cd,
  &lsh_help,
  &stop,
  &setshellname,
  &setterminator,
  &newname,
  &listnewnames,
  &savenewnames,
  &readnewnames
};
/*
Purpose: Get the number of element in the array
Parameters:char array
Returns: number of element in the char array
*/
int lsh_num_builtins() {
  return sizeof(builtin_str) / sizeof(char *);
}

//Builtin function implementations.
/*
Purpose:Terminates execustion of the current myshell session
Parameter: char array args no specific 
return: exit the shell command
 * /
/*
Purpose: Change a new shell command name if there is a input in args[1]
Parameters:char array args 1 will be shell name if inputed 
Returns: a new shellname if there is a change else is myshell
*/
int setshellname(char **args){
    if(args[1] == NULL){
      printf("Error: No new name is being declear\n");
      printf("Need to have a new name behind setshellname\n");
      shellname = "myshell";
    }else
    {
      printf("New shellname is set:: Shellname = %s\n",args[1]);
      
      shellname = args[1];
    }
    return 1;
} 
/*
Purpose: setting a new terminator if there is input for 
Parameters: char array args 1 will be the newterminator if inputed
Returns: a new terminator if there is input on args[1]
*/
int setterminator(char **args){
    if(args[1] == NULL){
      printf("Error: No new terminator is being declear\n");
      printf("Need to have a new name behind setterminator\n");
        terminator = ">";
    }else
    {
      printf("New terminator is set:: terminator = %s\n",args[1]);
        terminator = args[1];
    }
    return 1;
}
/*
Purpose: newname for build in program
Parameters:char arg of newnames and oldnames and buildin char
Returns: a new array of newnames and oldnames if exist
*/
int newname(char **args){
    if(args[1]==NULL||args[2]==NULL){
      printf("Error: Two arguments required\n");
      printf("Format: newname ARGUEMENT_ONE ARGUMENT_TWO\n");
      printf(        "ARGUEMENT_ONE :: OLD NAME\n");
      printf(        "ARGUEMENT_TWO :: NEW NAME\n");
      return 1;
    }
    int i = 0;
    while(i < lsh_num_newnames && oldnames[i]!=args[2]){
      i++;
    }
    if(args[2]==oldnames[i]){
      newnames[i]=args[1];
    }else{
      oldnames[lsh_num_newnames]=args[2];
      newnames[lsh_num_newnames]=args[1];
      lsh_num_newnames++; 
      }
    return 1;
}
/*
Purpose: Show all new command name thats is beening set
Parameters:char arg of newnames and oldnames
Returns: a list of newname and oldname printed 
*/
int listnewnames(char **args){
    for (int i = 0; i < lsh_num_newnames; i++) {
        printf("%s:%s\n",newnames[i],oldnames[i]);
    }
    return 1;
}
/*
Purpose:
Parameters:
Returns:
*/
int savenewnames(char **args){
    if(args[1]==NULL)
    {
      printf("Error: Arguement is empty\n");
      printf("Insert arguemnet behind savenewnames\n");
      return 1;
    }
    FILE* fp; // declare a file name
    fp=fopen(args[1],"w");//write to this file 
    for (int i = 0; i < lsh_num_newnames; i++) {
      fprintf(fp,newnames[i]);
            fprintf(fp," ");
      fprintf(fp,oldnames[i]);
       fprintf(fp,"\n");
    }
    fclose(fp);//clsoe file
    return 1;
}
/*
Purpose:
Parameters:
Returns:
*/
int readnewnames(char **args){
    if(args[1]==NULL)
    {
      printf("Error: Arguement is empty\n");
      printf("Insert arguemnet behind readnewnames\n");
      return 1;
    }
    FILE* fp; // declare a file name
    char buffer[100];
    fp=fopen(args[1],"r");//write to this file 
    for (int i = 0; i < lsh_num_newnames; i++) {
        fgets(buffer,100,fp);
        fprintf(stderr,buffer);
    }
    fclose(fp);//clsoe file
    return 1;
}

/*
Purpose:
Parameters:
Returns:
*/
int stop(char **args)
{
  return 0;
}

/**
   @brief Bultin command: change directory.
   @param args List of args.  args[0] is "cd".  args[1] is the directory.
   @return Always returns 1, to continue executing.
 */
int lsh_cd(char **args)
{
  if (args[1] == NULL) {
    fprintf(stderr, "lsh: expected argument to \"cd\"\n");
  } else {
    if (chdir(args[1]) != 0) {
      perror("lsh");
    }
  }
  return 1;
}

/**
   @brief Builtin command: print help.
   @param args List of args.  Not examined.
   @return Always returns 1, to continue executing.
 */
int lsh_help(char **args)
{
  int i;
  printf("Stephen Brennan's LSH\n");
  printf("Type program names and arguments, and hit enter.\n");
  printf("The following are built in:\n");

  for (i = 0; i < lsh_num_builtins(); i++) {
    printf("  %s\n", builtin_str[i]);
  }

  printf("Use the man command for information on other programs.\n");
  return 1;
}
/**
  @brief Launch a program and wait for it to terminate.
  @param args Null terminated list of arguments (including program).
  @return Always returns 1, to continue execution.
 */
int lsh_launch(char **args)
{
  pid_t pid, wpid;
  int status;

  pid = fork();
  if (pid == 0) {
    // Child process
    if (execvp(args[0], args) == -1) {
      perror("lsh");
    }
    exit(EXIT_FAILURE);
  } else if (pid < 0) {
    // Error forking
    perror("lsh");
  } else {
    // Parent process
    do {
      wpid = waitpid(pid, &status, WUNTRACED);
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));
  }

  return 1;
}

/**
   @brief Execute shell built-in or launch program.
   @param args Null terminated list of arguments.
   @return 1 if the shell should continue running, 0 if it should terminate
 */
int lsh_execute(char **args)
{
  int i;

  if (args[0] == NULL) {
    // An empty command was entered.
    return 1;
  }

  for(int i = 0; i < lsh_num_newnames; i++)
  {
  	if (strcmp(args[0],newnames[i])==0)
	{
		args[0] = oldnames[i];
	}
  }

  for (int i = 0; i < lsh_num_builtins(); i++) {
    if (strcmp(args[0], builtin_str[i]) == 0) {
      return (*builtin_func[i])(args);
    }
  }

  return lsh_launch(args);
}

#define LSH_RL_BUFSIZE 1024
/**
   @brief Read a line of input from stdin.
   @return The line from stdin.
 */
char *lsh_read_line(void)
{
  int bufsize = LSH_RL_BUFSIZE;
  int position = 0;
  char *buffer = malloc(sizeof(char) * bufsize);
  int c;

  if (!buffer) {
    fprintf(stderr, "lsh: allocation error\n");
    exit(EXIT_FAILURE);
  }

  while (1) {
    // Read a character
    c = getchar();

    // If we hit EOF, replace it with a null character and return.
    if (c == EOF || c == '\n') {
      buffer[position] = '\0';
      return buffer;
    } else {
      buffer[position] = c;
    }
    position++;

    // If we have exceeded the buffer, reallocate.
    if (position >= bufsize) {
      bufsize += LSH_RL_BUFSIZE;
      buffer = realloc(buffer, bufsize);
      if (!buffer) {
        fprintf(stderr, "lsh: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }
  }
}

#define LSH_TOK_BUFSIZE 64
#define LSH_TOK_DELIM " \t\r\n\a"
/**
   @brief Split a line into tokens (very naively).
   @param line The line.
   @return Null-terminated array of tokens.
 */
char **lsh_split_line(char *line)
{
  int bufsize = LSH_TOK_BUFSIZE, position = 0;
  char **tokens = malloc(bufsize * sizeof(char*));
  char *token;

  if (!tokens) {
    fprintf(stderr, "lsh: allocation error\n");
    exit(EXIT_FAILURE);
  }

  token = strtok(line, LSH_TOK_DELIM);
  while (token != NULL) {
    tokens[position] = token;
    position++;

    if (position >= bufsize) {
      bufsize += LSH_TOK_BUFSIZE;
      tokens = realloc(tokens, bufsize * sizeof(char*));
      if (!tokens) {
        fprintf(stderr, "lsh: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }

    token = strtok(NULL, LSH_TOK_DELIM);
  }
  tokens[position] = NULL;
  return tokens;
}

/**
   @brief Loop getting input and executing it.
 */
void lsh_loop(void)
{
  char *line;
  char **args;
  int status;

  do {
    printf("%s %s ", shellname, terminator);
    line = lsh_read_line();
    args = lsh_split_line(line);
    status = lsh_execute(args);

//    free(line);
//    free(args);
  } while (status);
}

/**
   @brief Main entry point.
   @param argc Argument count.
   @param argv Argument vector.
   @return status code
 */
int main(int argc, char **argv)
{
  // Load config files, if any.

  // Run command loop.
  lsh_loop();

  // Perform any shutdown/cleanup.

  return EXIT_SUCCESS;
}
