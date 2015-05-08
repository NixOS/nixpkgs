source $stdenv/setup

jar=${src##*/}
jar=$out/share/alloy/${jar#*-}

install -Dm644 $src $jar

cat << EOF > alloy
#! $SHELL
exec $jre/bin/java -jar $jar
EOF

install -Dm755 alloy $out/bin/alloy

install -Dm644 $icon $out/share/pixmaps/alloy.png
cp -r ${desktopItem}/share/applications $out/share
