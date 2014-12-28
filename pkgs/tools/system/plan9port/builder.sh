source $stdenv/setup

tar xvfz $src

cd plan9port

echo CFLAGS=\"-I${fontconfig}/include -I${libXt}/include\" > LOCAL.config
echo X11=\"${libXt}/include\" >> LOCAL.config

for p in $patches; do
  echo "applying patch $p"
  patch -p1 < $p
done

export PLAN9=$out/plan9
mkdir -p $PLAN9

for f in `grep -l -r /usr/local/plan9`; do
  sed "s,/usr/local/plan9,${PLAN9},g" -i $f
done

./INSTALL -r $PLAN9
cp -R * $PLAN9
