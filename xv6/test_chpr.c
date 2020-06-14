/*  ...................................
	this is the simple program for testing 
	the int chpr(int pid, int priority) 
	system call.
	It accepts pid, priority from command line respectively.
	It update the process's priority. On failure, return -1.
*/

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
	int priority, pid;
	if (argc < 3) {
		printf(2, "Usage: test_chpr pid priority\n");
		exit();
	}
	// string to integer conversion
	pid = atoi(argv[1]);
	priority = atoi(argv[2]);
	if (priority < 0 || priority > 20) {
		printf(2, "priority is not between 0-20\n");
	} 
	chpr(pid, priority);
	exit();
}