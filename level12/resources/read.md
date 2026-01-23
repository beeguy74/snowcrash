CGI Injection (Bad Sanitization)
Vulnerability: The Perl script executed a shell command using backticks: `egrep "^$xx" ...`. It attempted to sanitize the input $xx by converting all lowercase letters to uppercase (tr/a-z/A-Z/).

Why it worked: The sanitization was incomplete. It didn't affect symbols (like $ / *) or uppercase letters.

Bypass: By using shell wildcards (/???/TEST) instead of lowercase paths (/tmp/test), you bypassed the uppercase filter. The shell expanded the wildcards to the valid path, allowing execution.

Key Concept: "Blacklist" sanitization (blocking specific things like lowercase letters) is often insufficient. Filters must be comprehensive or use "whitelist" approaches.


echo -e '#!/bin/sh\ngetflag > /tmp/flag12' > /tmp/RUNME

chmod 777 /tmp/RUNME

curl 'http://localhost:4646/?x=$(/???/RUNME)'

cat /tmp/flag12
