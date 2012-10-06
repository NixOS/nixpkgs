{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "p7zip-9.20.1";
  
  src = fetchurl {
    url = mirror://sourceforge/p7zip/p7zip_9.20.1_src_all.tar.bz2;
    sha256 = "10j7rc1nzdp7vvcpc3340yi3qw7abby4szv8zkwh10d0zizpwma9";
  };

  preConfigure =
    ''
      makeFlagsArray=(DEST_HOME=$out)
      buildFlags=all3
    '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
    # license = "LGPLv2.1+"; + "unRAR restriction"
    platforms = stdenv.lib.platforms.unix;
  };
}
