/* ........................
 this is sample program to test 
 int cps(void) system call. It prints
 out the summary of all proccesses that
 are present in process table.
*/

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int 
main(int argc, char *argv[])
{
	// call to cps() system call
	cps();
	exit();
}
