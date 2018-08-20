{ stdenv, buildPackages, fetchurl, bison, m4
, fetchpatch, autoreconfHook, help2man
}:

stdenv.mkDerivation rec {
  name = "flex-${version}";
  version = "2.6.4";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v${version}/flex-${version}.tar.gz";
    sha256 = "15g9bv236nzi665p9ggqjlfn4dwck5835vf0bbw2cz7h5c1swyp8";
  };

  # Also upstream, will be part of 2.6.5
  # https://github.com/westes/flex/commit/24fd0551333e
  patches = [(fetchpatch {
    name = "glibc-2.26.patch";
    url = "https://raw.githubusercontent.com/lede-project/source/0fb14a2b1ab2f82c"
        + "/tools/flex/patches/200-build-AC_USE_SYSTEM_EXTENSIONS-in-configure.ac.patch";
    sha256 = "1aarhcmz7mfrgh15pkj6f7ikxa2m0mllw1i1vscsf1kw5d05lw6f";
  })];

  postPatch = ''
    patchShebangs tests
  '' + stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace Makefile.in --replace "tests" " "

    substituteInPlace doc/Makefile.am --replace 'flex.1: $(top_srcdir)/configure.ac' 'flex.1: '
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook help2man ];
  buildInputs = [ bison ];
  propagatedBuildInputs = [ m4 ];

  preConfigure = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  postConfigure = stdenv.lib.optionalString (stdenv.isDarwin || stdenv.isCygwin) ''
    sed -i Makefile -e 's/-no-undefined//;'
  '';

  dontDisableStatic = stdenv.buildPlatform != stdenv.hostPlatform;

  meta = with stdenv.lib; {
    homepage = https://github.com/westes/flex;
    description = "A fast lexical analyser generator";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
