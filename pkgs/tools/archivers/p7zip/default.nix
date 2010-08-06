{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "p7zip-9.13";
  
  src = fetchurl {
    url = mirror://sourceforge/p7zip/p7zip_9.13_src_all.tar.bz2;
    sha256 = "08yr0cfbjx60r1ia7vhphzvc3gax62xhgsn3vdm7sdmxxai0z77w";
  };

  preConfigure =
    ''
      makeFlagsArray=(DEST_HOME=$out)
      buildFlags=all3
    '';

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
    # license = "LGPLv2.1+"; + "unRAR restriction"
    platforms = stdenv.lib.platforms.unix;
  };
}
