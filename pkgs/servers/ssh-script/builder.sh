source $stdenv/setup

sed -e "s^@bash\@^$bash^g" \
    -e "s^@sshd\@\^$sshd^g" \
    -e "s^@initscripts\@\^$initscripts^g" \
    < $script > control
