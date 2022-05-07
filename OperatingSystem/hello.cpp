#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(void)
{
	printf("hello \n");
	fork();
	printf("bye\n");
	return 0;
}
