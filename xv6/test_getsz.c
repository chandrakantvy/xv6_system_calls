/* ...........................
 this is sample program to test 
 int getsz(void) system call.
 It return size allocated for
 current process.
*/

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
	int size;
	size = getsz();
	printf(1, "%d\n", size);
	exit();
}
