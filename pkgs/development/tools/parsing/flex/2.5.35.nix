{ stdenv, fetchurl, autoreconfHook, flex, bison, texinfo, help2man, m4 }:

stdenv.mkDerivation rec {
  name = "flex-2.5.35";

  src = fetchurl {
    url = https://github.com/westes/flex/archive/flex-2-5-35.tar.gz;
    sha256 = "0wh06nix8bd4w1aq4k2fbbkdq5i30a9lxz3xczf3ff28yy0kfwzm";
  };

  nativeBuildInputs = [ flex bison texinfo help2man autoreconfHook ];

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
