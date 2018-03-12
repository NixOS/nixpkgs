{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "musl-getconf";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/alpinelinux/aports/48b16204aeeda5bc1f87e49c6b8e23d9abb07c73/main/musl/getconf.c";
    sha256 = "0z14ml5343p5gapxw9fnbn2r72r7v2gk8662iifjrblh6sxhqzfq";
  };

  unpackPhase = ":";

  buildPhase = ''$CC $src -o getconf'';
  installPhase = ''
    mkdir -p $out/bin
    cp getconf $out/bin/
  '';
}


