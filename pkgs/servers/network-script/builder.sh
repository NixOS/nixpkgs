source $stdenv/setup

ensureDir $out

sed -e "s^@bash\@^$bash^g" \
    -e "s^@dhcp\@^$dhcp^g" \
    -e "s^@nettools\@^$nettools^g" \
    < $script > $out/$nicename

chmod +x $out/$nicename
