/*  ..........................................
	this is the sample program to test
	int time(int *waitt, *burstt) system call.
	It updates waitt and burstt variable with 
	wait time and burst time and return pid.
*/

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main (int argc,char *argv[])
{

 int pid;
 int status = 0, a = 3, b = 4;	
 pid = fork ();
 if (pid == 0)
   {	
   exec(argv[1],argv);
    printf(1, "exec %s failed\n", argv[1]);
    }
  else
 {
    status = time(&a,&b);
 }  
 printf(1, "Wait Time = %d\n Run Time = %d with Status %d \n",a,b,status); 
 exit();
}