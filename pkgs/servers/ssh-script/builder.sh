source $stdenv/setup

ensureDir $out

sed -e "s^@bash\@^$bash^g" \
    -e "s^@sshd\@^$ssh^g" \
    -e "s^@initscripts\@^$initscripts^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    < $script > $out/control

chmod +x $out/control
