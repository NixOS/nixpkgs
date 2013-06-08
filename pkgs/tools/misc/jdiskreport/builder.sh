source $stdenv/setup

unzip $src

jar=$(ls */*.jar)

mkdir -p $out/lib/java
mv $jar $out/lib/java

mkdir -p $out/bin
cat > $out/bin/jdiskreport <<EOF
#! $SHELL -e
exec $jre/bin/java -jar $out/lib/java/$(basename $jar)
EOF
chmod +x $out/bin/jdiskreport
