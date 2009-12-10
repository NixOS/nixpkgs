{ stdenv, fetchurl, freetype, fontconfig, libunwind, libtool, flex, bison }:

stdenv.mkDerivation {
  name = "ttf-mkfontdir-3.0.9-5.1";

  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/t/ttmkfdir/ttmkfdir_3.0.9.orig.tar.gz;
    sha256 = "0n6bmmndmp4c1myisvv7cby559gzgvwsw4rfw065a3f92m87jxiq";
  };
    
  # all the patches up from ttmkfdir-3.0.9/Makefile should be reviewed by someone
  # who knows more about C/C++ ..
  patches =
    [ (fetchurl {
        url = http://ftp.de.debian.org/debian/pool/main/t/ttmkfdir/ttmkfdir_3.0.9-5.1.diff.gz;
        sha256 = "1500kwvhxfq85zg7nwnn9dlvjxyg2ni7as17gdfm67pl9a45q3w4";
      })
    
      ./cstring.patch # also fixes some other compilation issues (freetype includes)
    ];

  preInstall = ''
    ensureDir $out; makeFlags="DESTDIR=$out BINDIR=/bin"
  '';

  buildInputs = [freetype fontconfig libunwind libtool flex bison];

  meta = {
    description = "Create fonts.dir for TTF font directory.";
  };
}
