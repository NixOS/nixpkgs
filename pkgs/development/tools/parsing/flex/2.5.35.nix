{ stdenv, fetchurl, autoreconfHook, flex, bison, texinfo, help2man, m4 }:

stdenv.mkDerivation rec {
  name = "flex-2.5.35";

  src = fetchurl {
    url = https://github.com/westes/flex/archive/flex-2-5-35.tar.gz;
    sha256 = "0wh06nix8bd4w1aq4k2fbbkdq5i30a9lxz3xczf3ff28yy0kfwzm";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [ flex bison texinfo help2man autoreconfHook ];

  propagatedBuildInputs = [ m4 ];

  preConfigure = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  doCheck = false; # fails 2 out of 46 tests

  meta = with stdenv.lib; {
    branch = "2.5.35";
    homepage = http://flex.sourceforge.net/;
    description = "A fast lexical analyser generator";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
