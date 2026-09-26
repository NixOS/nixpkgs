{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  flex,
  bison,
  texinfo,
  help2man,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flex";
  version = "2.5.35";

  src = fetchurl {
    url = "https://github.com/westes/flex/archive/flex-${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }.tar.gz";
    hash = "sha256-9XM3gfdIODfcZ338TpMCIxbc5lpOTIJV4KQt1KM1AHI=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [
    flex
    bison
    texinfo
    help2man
    autoreconfHook
  ];

  propagatedBuildInputs = [ m4 ];

  strictDeps = true;

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    ac_cv_func_malloc_0_nonnull=yes
    ac_cv_func_realloc_0_nonnull=yes
  '';

  doCheck = false; # fails 2 out of 46 tests

  __structuredAttrs = true;

  meta = {
    branch = "2.5.35";
    homepage = "https://flex.sourceforge.net/";
    description = "Fast lexical analyser generator";
    mainProgram = "flex";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
