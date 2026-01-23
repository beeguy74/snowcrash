
in ~/ we have two files:
- level08 binary
- token

level08 binary reads file with flag08 rights, but it won't read the token, so we can create a symlink to it
```bash
ln -s /home/user/level08/token /tmp/ok.link
./level08 /tmp/ok.link
# its a pass to flag08 user which can run getflag!
```
