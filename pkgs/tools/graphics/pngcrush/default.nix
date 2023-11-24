{ lib, stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  pname = "pngcrush";
  version = "1.8.13";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/pngcrush-${version}-nolib.tar.xz";
    sha256 = "0l43c59d6v9l0g07z3q3ywhb8xb3vz74llv3mna0izk9bj6aqkiv";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "LD=${stdenv.cc.targetPrefix}cc" ];      # gcc and/or clang compat

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = "http://pmt.sourceforge.net/pngcrush";
    description = "A PNG optimizer";
    license = lib.licenses.free;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "pngcrush";
  };
}
