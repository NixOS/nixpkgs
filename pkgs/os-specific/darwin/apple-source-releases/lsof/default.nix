{ stdenv, appleDerivation, ncurses }:

appleDerivation {
  buildInputs = [ ncurses ];

  postUnpack = ''
    sourceRoot="$sourceRoot/lsof"
  '';

  prePatch = ''
    mv Configure configure
    substituteInPlace configure \
      --replace '`which make`' "$(type -P make)" \
      --replace /usr/include "${stdenv.libc}/include" \
      --replace -lcurses -lncurses
  '';

  dontAddPrefix = true;

  configureFlags = [ "-n" "darwin" ];

  installPhase = ''
    mkdir -p $out/bin $out/man/man8
    cp lsof.8 $out/man/man8/
    cp lsof $out/bin
  '';
}
