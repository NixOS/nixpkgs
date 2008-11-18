#! /bin/sh -e

tmpDir=/tmp/event.d

mkdir -p /tmp/event.d

if test "$(readlink -f /etc/event.d)" != /tmp/event.d; then 
    cp -prd "$(readlink -f /etc/event.d)"/* /tmp/event.d/
fi

for i in $*; do
    echo "building job $i..."
    nix-build /etc/nixos/nixos -A "tests.upstartJobs.$i" -o $tmpDir/.result
    ln -sfn $(readlink -f $tmpDir/.result)/etc/event.d/* /tmp/event.d/
done

ln -sfn /tmp/event.d /etc/event.d

echo "restarting init..."
kill -TERM 1 

sleep 1

for i in $*; do
    echo "restarting job $i..."
    initctl stop "$i"
    sleep 1
    initctl start "$i"
done    
