source $STDENV/setup

mkdir $OUT
cd $OUT
tar zxvf $SRC

test -x $OUT/nix-support || mkdir $OUT/nix-support
cp $SETUPHOOK $OUT/nix-support/setup-hook
