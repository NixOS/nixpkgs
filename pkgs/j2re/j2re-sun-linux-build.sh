#! /bin/sh

mkdir -p $out    || exit 1
cd $out          || exit 1
tail +473 $binzip > j2re.exe || exit 1
chmod u+x j2re.exe || exit 1
./j2re.exe      || exit 1
rm j2re.exe     || exit 1
mv j2re1.4.2/* . || exit 1
rmdir j2re1.4.2  || exit 1

PACKED_JARS="lib/rt lib/jsse lib/charsets lib/ext/localedata lib/plugin javaws/javaws"

for i in $PACKED_JARS; do
  lib/unpack $i.pack $i.jar || exit 1
done