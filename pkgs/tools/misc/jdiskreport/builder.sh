source $stdenv/setup

unzip $src

jar=$(ls */*.jar)

mkdir -p $out/share/java
mv $jar $out/share/java

mkdir -p $out/bin
cat > $out/bin/jdiskreport <<EOF
#! $SHELL -e
exec $jre/bin/java -jar $out/share/java/$(basename $jar)
EOF
chmod +x $out/bin/jdiskreport
