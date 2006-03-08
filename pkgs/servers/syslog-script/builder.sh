source $stdenv/setup

ensureDir $out

sed -e "s^@bash\@^$bash^g" \
    -e "s^@syslog\@^$syslog^g" \
    -e "s^@nicename\@^$nicename^g" \
    < $script > $out/$nicename

chmod +x $out/$nicename
