source $stdenv/setup

boot_bin=$out/bin/boot

mkdir -pv $(dirname $boot_bin)
cp -v $src $boot_bin
chmod -v 755 $boot_bin

patchShebangs $boot_bin

sed -i \
  -e "2iexport JAVA_HOME=${jdk}" \
  -e "2iexport PATH=${jdk}/bin\${PATH:+:}\$PATH" \
  $boot_bin
