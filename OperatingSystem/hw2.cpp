
#include <iostream>
#include <unistd.h>
#include <sys/wait.h>
using namespace std;

int main(int argc, char* argv[]){
	if(argc<=2)
	{
		cout <<  "Error myCat: Not enough argument"<< endl;
		return 0;
	}
	int status;
	pid_t forkreturn;
	forkreturn = fork();

	if(forkreturn == 0)
	{
		cout << "In the CHILD process Trying to meow"<< endl;
		cout << "Child Process ID: "<<getpid()<<", Parent ID: "<< getppid() << ", Process Group: "<< getpgrp()<<endl;

		execl("/bin/cat","cat","-n",argv[1],"-",argv[2], NULL);
		printf("If this line occur then execv failed \n");

	}else if (forkreturn > 0){
		wait(&status);
		cout << "In the Parent Process"<< endl;
		cout << "Origional Process ID: " << getpid() << ", Parent Is: " << getppid() << ", Process Group is: " << getpgrp() << endl;
	}else{

		cout << "Error " << endl;
	}




	return 0;


}
