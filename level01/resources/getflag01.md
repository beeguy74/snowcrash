normally hashes of users password shoul be in  `passwd` + `shadow` file, but here we have everything in the not protected passwd: 
Hash of password of flag01 is in /etc/passwd  file:
```
flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
```
John the reaper can break it like ```john [--format=yescript] hash.txt  [--wordlist=somelist.txt]```