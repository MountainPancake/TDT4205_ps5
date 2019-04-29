#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/*
def improve ( n, estimate )
begin
    var next
    next := estimate - ( (estimate * estimate - n) / ( 2 * estimate ) )
    if next - estimate = 0 then
        // Integer precision converges at smallest int greater than the square
        return next-1
    else
        return improve ( n, next )
end
*/

int improve (int n, int estimate)
{
    int next;
    next = estimate - ( (estimate * estimate - n) / ( 2 * estimate ) );
    if (next - estimate == 0)
        // Integer precision converges at smallest int greater than the square
        return next-1;
    else
        return improve ( n, next );
}

int main (int argc, const char **argv)
{
    int n = atoi(argv[1]);
    printf("The square root of %d is %d\n", n, improve ( n, 1 ));
}
