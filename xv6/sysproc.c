#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"
#ifdef PDX_XV6
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  xticks = ticks;
  return xticks;
}

#ifdef PDX_XV6
// shutdown QEMU
int
sys_halt(void)
{
  do_shutdown();  // never returns
  return 0;
}
#endif // PDX_XV6

/* _________________My System Calls________________ */

int sys_cps(void) {
  return cps();
}

int sys_getppid(void) {
  return getppid();
}

int sys_getsz(void) {
  return getsz();
}

int sys_chpr(void) {
  int pid, priority;
  if (argint(0, &pid) < 0)
    return -1;
  if (argint(1, &priority) <0 )
    return -1;
  return chpr(pid, priority);
}

int sys_getcount(void) {
  int procno;
  if (argint(0, &procno) < 0)
    return -1;
  return getcount(procno);
}

int sys_time(void)
{
  int *waitt;
  int *burstt;
  
  if(argptr(0, (char**)&waitt, sizeof(int)) < 0)
    return 12;

  if(argptr(1, (char**)&burstt, sizeof(int)) < 0)
    return 13;

  return time(waitt,burstt);
}

int sys_utctime(void)
{
  struct rtcdate *r;
  if(argptr(0, (void*)&r, sizeof(r)) < 0)
   return -1;
  return utctime(r);
 }

 /* ________________________________________________ */