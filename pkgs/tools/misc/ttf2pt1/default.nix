{ stdenv, fetchurl, perl, freetype }:

stdenv.mkDerivation {
  name = "ttf2pt1-3.4.4";

  src = fetchurl {
    url = mirror://sourceforge/ttf2pt1/ttf2pt1-3.4.4.tgz;
    sha256 = "1l718n4k4widx49xz7qrj4mybzb8q67kp2jw7f47604ips4654mf";
  };

  preConfigure = ''
    find -type f | xargs sed -i 's@/usr/bin/perl@${perl}/bin/perl@'
    mkdir -p $out
    sed -e 's/chown/true/' \
        -e 's/chgrp/true/' \
        -e 's@^CFLAGS_FT =.*@CFLAGS_FT=-DUSE_FREETYPE -I${freetype.dev}/include/freetype2@' \
        -i scripts/{inst_dir,inst_file} Makefile
    makeFlags="INSTDIR=$out OWNER=`id -u`"
  '';

  buildInputs = [ freetype ];
  nativeBuildInputs = [ perl ];
  
  patches = ./gentoo-makefile.patch; # also contains the freetype patch

  meta = { 
    description = "True Type to Postscript Type 3 converter, fpdf";
    homepage = "http://ttf2pt1.sourceforge.net/index.html";
    license = "ttf2pt1";
  };
}
