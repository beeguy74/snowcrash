The program level13 used the standard library function getuid() to check if the user had authorization to receive the token. It essentially asked the operating system: "Who is running me?" and trusted the answer implicitly.

We have created the fake library that contains custom getuid() function:

echo '#include <sys/types.h>
uid_t getuid(void) {
return 4242;
}' > /tmp/fake.c

gcc -fPIC -shared -o /tmp/fake.so /tmp/fake.c

cp ./level13 /tmp/level13_copy

Than we put it to the LD_PRELOAD variable that let us load our own libraries before standart ones.

LD_PRELOAD=/tmp/fake.so /tmp/level13_copy
