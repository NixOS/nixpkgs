{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation rec {
  name = "flex-2.5.35";

  src = fetchurl {
    # Deleted from original SourceForge and GitHub only provides generated file.
    # Note: binary cache still seems to serve it, too.
    url = "http://downloads.openwrt.org/sources/${name}.tar.bz2";
    sha256 = "0ysff249mwhq0053bw3hxh58djc0gy7vjan2z1krrf9n5d5vvv0b";
  };

  buildInputs = [ bison ];

  propagatedNativeBuildInputs = [ m4 ];

  crossAttrs = {
    preConfigure = ''
      export ac_cv_func_malloc_0_nonnull=yes
      export ac_cv_func_realloc_0_nonnull=yes
    '';
  };

  meta = {
    branch = "2.5.35";
    homepage = http://flex.sourceforge.net/;
    description = "A fast lexical analyser generator";
    platforms = stdenv.lib.platforms.unix;
  };
}
