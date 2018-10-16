{ stdenv, fetchgit }:
let
  version = "2018-09-17";
in stdenv.mkDerivation rec {
  name = "edid-decode-unstable-${version}";

  src = fetchgit {
    url = "git://linuxtv.org/edid-decode.git";
    rev = "5eeb151a748788666534d6ea3da07f90400d24c2";
    sha256 = "1v9rnq7b6hh6my47pj879z5jap0amg17r9mbjfra8dmmfgy09m3g";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp edid-decode $out/bin
  '';

  meta = {
    description = "EDID decoder and conformance tester";
    homepage = https://cgit.freedesktop.org/xorg/app/edid-decode/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.chiiruno ];
    platforms = stdenv.lib.platforms.all;
  };
}

