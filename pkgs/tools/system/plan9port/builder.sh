source $stdenv/setup

tar xvfz $src

cd plan9port

cflags="echo \"CFLAGS='-I${libXt}/include'\" >> \$PLAN9/config"

sed -i "43i\\${cflags}" INSTALL

for p in $patches; do
  echo "applying patch $p"
  patch -p1 < $p
done

./INSTALL -r $out/plan9

export PLAN9=$out/plan9
mkdir -p $PLAN9
cp -R * $PLAN9
