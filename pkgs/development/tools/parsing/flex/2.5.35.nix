{ lib, stdenv, fetchurl, autoreconfHook, flex, bison, texinfo, help2man, m4 }:

stdenv.mkDerivation rec {
  pname = "flex";
  version = "2.5.35";

  src = fetchurl {
    url = "https://github.com/westes/flex/archive/flex-${lib.replaceStrings ["."] ["-"] version}.tar.gz";
    sha256 = "0wh06nix8bd4w1aq4k2fbbkdq5i30a9lxz3xczf3ff28yy0kfwzm";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [ flex bison texinfo help2man autoreconfHook ];

  propagatedBuildInputs = [ m4 ];

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    ac_cv_func_malloc_0_nonnull=yes
    ac_cv_func_realloc_0_nonnull=yes
  '';

  doCheck = false; # fails 2 out of 46 tests

  meta = with lib; {
    branch = "2.5.35";
    homepage = "https://flex.sourceforge.net/";
    description = "Fast lexical analyser generator";
    mainProgram = "flex";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
