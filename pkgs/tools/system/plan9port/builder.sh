source $stdenv/setup

tar xvfz $src

cd plan9

for p in $patches; do
  echo "applying patch $p"
  patch -p1 < $p
done

./INSTALL -b
./INSTALL -r $out/plan9

export PLAN9=$out/plan9
mkdir -p $PLAN9
cp -R * $PLAN9
