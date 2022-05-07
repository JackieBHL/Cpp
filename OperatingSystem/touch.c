#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
char buf[512];
int
main(int argc, char *argv[])
{
	//check if there are input filename
     if(argc<2)
    {
        printf(1,"Please enter the name you want for the empty file");
        exit();
    }
    int i,err;
    for(i=1;i<argc;i++)
    {
        if((err=open(argv[i],O_CREATE|O_RDWR)) < 0)
        {
            printf(1,"touch: error where creating %s\n",argv[i]);
            exit();
        }
        close(err);
    }
    exit();
}
