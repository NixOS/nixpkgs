source $stdenv/setup

unzip $src

ensureDir $out/jars
mv */*.jar $out/jars
jar=$(ls $out/jars/jdiskreport-*.jar)

ensureDir $out/bin
cat > $out/bin/jdiskreport <<EOF
#! $SHELL -e
exec $jdk/bin/java -jar $jar
EOF
chmod +x $out/bin/jdiskreport
