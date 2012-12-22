{ stdenv, gccRaw }:

stdenv.mkDerivation {
  name = "distcc-masq-${gccRaw.name}";

  phases = [ "installPhase" ];
  installPhase = ''
    ensureDir $out/bin

    bin=${gccRaw}/bin

    shopt -s nullglob
    if [ -f $bin/gcc ]; then
      ln -s $bin/gcc $out/bin
    else
      for a in $bin/*-g++; do
        ln -s $bin/*-gcc $out/bin/gcc
      done
    fi

    if [ -f $bin/g++ ]; then
      ln -s $bin/g++ $out/bin
    else
      for a in $bin/*-g++; do
        ln -sf $bin/*-g++ $out/bin/g++
      done
    fi
  '';
}
