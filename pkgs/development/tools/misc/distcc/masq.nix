{ stdenv, gccRaw, binutils }:

stdenv.mkDerivation {
  name = "distcc-masq-${gccRaw.name}";

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin

    bin=${gccRaw}/bin

    shopt -s nullglob
    if [ -f $bin/gcc ]; then
      ln -s $bin/gcc $out/bin
    else
      for a in $bin/*-gcc; do
        ln -s $bin/*-gcc $out/bin/gcc
        ln -s $bin/*-gcc $out/bin/cc
      done
    fi

    if [ -f $bin/g++ ]; then
      ln -s $bin/g++ $out/bin
    else
      for a in $bin/*-g++; do
        ln -sf $bin/*-g++ $out/bin/g++
        ln -sf $bin/*-g++ $out/bin/c++
      done
    fi

    bbin=${binutils}/bin
    if [ -f $bbin/as ]; then
      ln -s $bbin/as $out/bin
    else
      for a in $bbin/*-as; do
        ln -sf $bbin/*-as $out/bin/as
      done
    fi
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
