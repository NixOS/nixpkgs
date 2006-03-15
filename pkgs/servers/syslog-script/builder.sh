source $stdenv/setup

ensureDir $out

sed -e "s^@bash\@^$bash^g" \
    -e "s^@syslog\@^$syslog^g" \
    -e "s^@nicename\@^$nicename^g" \
    -e "s^@initscripts\@^$initscripts^g" \
    < $script > $out/control

chmod +x $out/control
