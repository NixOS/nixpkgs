source $stdenv/setup
source $makeWrapper

makeWrapper "$findutils/bin/locate" "$out/bin/locate" \
--set LOCATE_PATH /var/locatedb

makeWrapper "$findutils/bin/updatedb" "$out/bin/updatedb" \
--set LOCATE_DB /var/locatedb

makeWrapper "$findutils/bin/find" "$out/bin/find"

makeWrapper "$findutils/bin/xargs" "$out/bin/xargs"
