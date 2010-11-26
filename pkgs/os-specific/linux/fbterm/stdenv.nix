# Quick version to be able to cross-build fbterm meanwhile builderDefs cannot
# cross-build with an equivalent to the stdenvCross adapter.
{ stdenv, fetchurl, gpm, freetype, fontconfig, pkgconfig, ncurses }:

let
  version="1.5";
  name="fbterm-1.5";
  hash="05qzc6g9a79has3cy7dlw70n4pn13r552a2i1g4xy23acnpvvjsb";
  url="http://fbterm.googlecode.com/files/fbterm-${version}.tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    inherit url;
    sha256 = hash;
  };

  buildNativeInputs = [ ncurses ];
  buildInputs = [ gpm freetype fontconfig pkgconfig ];

  patchPhase = ''
    sed -e '/ifdef SYS_signalfd/atypedef long long loff_t;' -i src/fbterm.cpp

    sed -e '/install-exec-hook:/,/^[^\t]/{d}; /.NOEXPORT/iinstall-exec-hook:\
    ' -i src/Makefile.in

    export HOME=$PWD;

    export NIX_LDFLAGS="$NIX_LDFLAGS -lfreetype"
    # This is only relevant cross-building
    export NIX_CROSS_LDFLAGS="$NIX_CROSS_LDFLAGS -lfreetype"
  '';
}
