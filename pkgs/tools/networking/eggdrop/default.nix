{ stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  name = "eggdrop-${version}";
  version = "1.6.21";

  src = fetchurl {
    url = "ftp://ftp.eggheads.org/pub/eggdrop/GNU/1.6/eggdrop${version}.tar.gz";
    sha256 = "1galvbh9y4c3msrg1s9na0asm077mh1g2i2vsv1vczmfrbgq92vs";
  };

  buildInputs = [ tcl ];

  patches = [
    # https://github.com/eggheads/eggdrop/issues/123
    ./b34a33255f56bbd2317c26da12d702796d67ed50.patch
  ];

  preConfigure = ''
    prefix=$out/eggdrop
    mkdir -p $prefix
  '';

  postConfigure = ''
    make config
  '';

  configureFlags = [
    "--with-tcllib=${tcl}/lib/lib${tcl.libPrefix}.so"
    "--with-tclinc=${tcl}/include/tcl.h"
  ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
