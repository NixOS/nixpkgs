set -e
source $stdenv/setup

$unzip/bin/unzip $src
mkdir -p $out
mv $name/* $out

cat > "$out/bin/jing" <<EOF
#! $SHELL
export JAVA_HOME="$jre"
exec "$jre/bin/java" -jar "$out/bin/jing.jar" "\$@"
EOF

chmod a+x "$out/bin/jing"
