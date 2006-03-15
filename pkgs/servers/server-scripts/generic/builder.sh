source $stdenv/setup

ensureDir $out

sed -e "s^@bash\@^$bash^g" \
    -e "s^@sshd\@^$ssh^g" \
    -e "s^@initscripts\@^$initscripts^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@nixpkgs\@^$nixpkgs^g" \
    -e "s^@nix\@^$nix^g" \
    < $functions > $out/$nicename
