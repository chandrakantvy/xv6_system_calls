/* ...................................
   this is the sample program to test
   int utctime(struct rtcdate *r) that 
   update r with current UTC time.
   Returns 0 on success, -1 on failure.
*/

#include "types.h"
#include "user.h"
#include "date.h"

int main(int argc, char *argv[])
{
  struct rtcdate r;

  if (utctime(&r)) {
    printf(2, "date failed\n");
    exit();
  }
  printf(1, "Current UTC Time: ");
  printf(1, "%d:%d:%d ", r.hour, r.minute, r.second);
  printf(1, "%d-%d-%d\n",  r.day, r.month, r.year);

  exit();
}