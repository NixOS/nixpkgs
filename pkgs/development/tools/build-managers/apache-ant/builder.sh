. $stdenv/setup || exit 1

tar xvfj $src || exit 1

mkdir -p $out
mv apache-ant-1.6.0/* $out || exit 1

rm -rf $out/docs
rm $out/*

confpath=$out/etc/nixpaths.conf || exit 1
sed "s^.etc.ant.conf^$confpath^g" $out/bin/ant > $out/bin/ant_temp || exit 1
mv $out/bin/ant_temp $out/bin/ant || exit 1
chmod u+xrw $out/bin/ant || exit 1
chmod u+x $out/bin/* || exit 1
echo "
JAVA_HOME=$j2sdk
ANT_HOME=$out
" > $confpath || exit 1
