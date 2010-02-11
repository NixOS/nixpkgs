#! /bin/sh -e

for i in $*; do
    echo "building job $i..."
    nix-build /etc/nixos/nixos -A "config.jobs.$i" -o $tmpDir/.result
    # !!! Here we assume that the attribute name equals the Upstart
    # job name.
    ln -sfn $(readlink -f $tmpDir/.result) /etc/init/"$i".conf
done

echo "restarting init..."
initctl reload-configuration

sleep 1

for i in $*; do
    echo "restarting job $i..."
    initctl stop "$i" || true
    initctl start "$i"
done    
