/* ........................................
   this is the sample program created for 
   creating dummy processes to test 
   priority added to struct proc of process.
*/

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
	int n, id, p=1;
	// n is for number of children to be produced
	if (argc < 2)
		n = 1;
	else
		n = atoi(argv[1]);
	if (n < 0 || n > 20)
		n = 2;

	id = 0;
	for(int i = 0; i < n; i++) {
		id = fork();
		if (id < 0) 
			printf(1, "%d couldn't create child\n", getpid());
		else if (id > 0){
			printf(1, "parent = %d\n", getpid());
			wait();
		} 
		else {
			printf(1, "Child = %d\n",getpid());
			for(int j = 1; j < 1000000000; j++)
				p = p + j * p;             // dummy calculations to consume cpu's processing power
			break;
		}
	}
	// test_cps() => use this call here to current 
	// process status along with there priority
	exit();
}
