// System call numbers -- Portland State University version
#define SYS_fork    1
#define SYS_exit    SYS_fork+1
#define SYS_wait    SYS_exit+1
#define SYS_pipe    SYS_wait+1
#define SYS_read    SYS_pipe+1
#define SYS_kill    SYS_read+1
#define SYS_exec    SYS_kill+1
#define SYS_fstat   SYS_exec+1
#define SYS_chdir   SYS_fstat+1
#define SYS_dup     SYS_chdir+1
#define SYS_getpid  SYS_dup+1
#define SYS_sbrk    SYS_getpid+1
#define SYS_sleep   SYS_sbrk+1
#define SYS_uptime  SYS_sleep+1
#define SYS_open    SYS_uptime+1
#define SYS_write   SYS_open+1
#define SYS_mknod   SYS_write+1
#define SYS_unlink  SYS_mknod+1
#define SYS_link    SYS_unlink+1
#define SYS_mkdir   SYS_link+1
#define SYS_close   SYS_mkdir+1
#define SYS_halt    SYS_close+1
// student system calls begin here. Follow the existing pattern.

// My System Calls
#define SYS_cps     SYS_halt+1           // current process summary
#define SYS_getppid	SYS_cps+1			 // get parent process id
#define SYS_getsz	SYS_getppid+1		 // get size of the process 
#define SYS_chpr 	SYS_getsz+1			 // change priority of the process
#define SYS_getcount SYS_chpr+1  		 // get count of system call in a process
#define SYS_time	SYS_getcount+1			
#define SYS_utctime SYS_time+1
#define SYS_dup2    SYS_utctime+1
