# SnowCrash - Penetration Testing CTF Challenge Guide

## Level 14

We will use gdb disassembler to exploit the /bin/getflag function

Steps:
1. gdb /bin/getflag
2. disas main
3. there are 3 breakpoints
4. break *main
5. break *0x0804898e
6. break *0x08048b02
7. run
8. continue
9. set $eax = 0 (we change the result of ptrace function)
10. continue
11. set $eax = 3014 (3014 is UID of flag14 user ( watch cat /etc/passwd))
12. continue

