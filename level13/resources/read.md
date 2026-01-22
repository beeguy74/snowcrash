echo '#include <sys/types.h>
uid_t getuid(void) {
return 4242;
}' > /tmp/fake.c

gcc -fPIC -shared -o /tmp/fake.so /tmp/fake.c

cp ./level13 /tmp/level13_copy
LD_PRELOAD=/tmp/fake.so /tmp/level13_copy
