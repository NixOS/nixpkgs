source $stdenv/setup

ensureDir $out

sed -e "s^@bash\@^$bash^g" \
    -e "s^@sshd\@^$ssh^g" \
    -e "s^@initscripts\@^$initscripts^g" \
    < $script > $out/control
