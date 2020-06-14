/* ..............................
 this is the sample program is to
 test int getppid(void) system call.
 It returns process id of parent process.
*/

#include "types.h"
#include "user.h"

int main(void) {
    int parent = getpid();
    int child = fork();                  // replicate the current process
    if(child == 0) {
        printf(1, "child: parent=%d child=%d getpid()=%d getppid()=%d\n",
                parent, child, getpid(), getppid());
    } else {
        wait();
        printf(1, "parent: parent=%d child=%d getpid()=%d getppid()=%d\n",
                parent, child, getpid(), getppid());
    }
    exit();
}
