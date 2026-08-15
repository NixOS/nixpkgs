{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  bison,
  m4,
  autoreconfHook,
  help2man,
}:

# Avoid 'fetchpatch' to allow 'flex' to be used as a possible 'gcc'
# dependency during bootstrap. Useful when gcc is built from snapshot
# or from a git tree (flex lexers are not pre-generated there).

stdenv.mkDerivation (finalAttrs: {
  pname = "flex";
  version = "2.6.4";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v${finalAttrs.version}/flex-${finalAttrs.version}.tar.gz";
    hash = "sha256-6HquAyvwfCb4WsDtMlCZjDdiHZX4vXSLMfFbM8Re6ZU=";
  };

  patches = [
    (fetchurl {
      # Also upstream, will be part of 2.6.5
      # https://github.com/westes/flex/commit/24fd0551333e
      name = "glibc-2.26.patch";
      url = "https://raw.githubusercontent.com/lede-project/source/0fb14a2b1ab2f82ce63f4437b062229d73d90516/tools/flex/patches/200-build-AC_USE_SYSTEM_EXTENSIONS-in-configure.ac.patch";
      hash = "sha256-eSDA0hIIfQbXx0DP1dTQU2uIqBxIXjbB6O+E134g91Y=";
    })
    (fetchurl {
      name = "gcc-15.patch";
      url = "https://github.com/westes/flex/commit/bf254c75b1e0d2641ebbd7fc85fb183f36a62ea7.patch";
      hash = "sha256-Bnv23M2K1Qf7pEaEz0ueSNzTCdjMTDiMm+H7JaxUISs=";
    })
  ];

  postPatch = ''
    patchShebangs tests
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace Makefile.in --replace "tests" " "

    substituteInPlace doc/Makefile.am --replace 'flex.1: $(top_srcdir)/configure.ac' 'flex.1: '
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    help2man
  ];
  buildInputs = [ bison ];
  propagatedBuildInputs = [ m4 ];

  strictDeps = true;

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    export ac_cv_func_malloc_0_nonnull=yes
    export ac_cv_func_realloc_0_nonnull=yes
  '';

  postConfigure = lib.optionalString (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isCygwin) ''
    sed -i Makefile -e 's/-no-undefined//;'
  '';

  dontDisableStatic = stdenv.buildPlatform != stdenv.hostPlatform;

  postInstall = ''
    ln -s $out/bin/flex $out/bin/lex
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/westes/flex";
    description = "Fast lexical analyser generator";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
