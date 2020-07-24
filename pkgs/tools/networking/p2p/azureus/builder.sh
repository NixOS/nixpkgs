source $stdenv/setup

mkdir -p $out/jars
cp $src $out/jars/azureus.jar

mkdir -p $out/bin
cat > $out/bin/azureus <<EOF
#! $SHELL -e
azureusHome=$out
if test -n "\$HOME"; then
    azureusHome=\$HOME/.Azureus
fi
exec $jdk/bin/java -Xms16m -Xmx128m \
  -cp $out/jars/azureus.jar:$swt/jars/swt.jar \
  -Djava.library.path=$swt/lib \
  -Dazureus.install.path=\$azureusHome \
  org.gudy.azureus2.ui.swt.Main
EOF
chmod +x $out/bin/azureus
