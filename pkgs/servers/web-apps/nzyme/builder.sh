source $stdenv/setup

jar=$src

mkdir -p $out/share/java
cp $jar $out/share/java/nzyme.jar

mkdir -p $out/bin
cat > $out/bin/nzyme <<EOF
#! $SHELL -e
exec $jre/bin/java -jar $out/share/java/nzyme.jar --config-file \$1
EOF
chmod +x $out/bin/nzyme
