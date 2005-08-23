. $stdenv/setup
. $makeWrapper

makeWrapper "$findutils/bin/locate" "$out/bin/locate" \
--database=/var/locatedb

makeWrapper "$findutils/bin/updatedb" "$out/bin/updatedb" \
--set LOCATE_DB /var/locatedb
