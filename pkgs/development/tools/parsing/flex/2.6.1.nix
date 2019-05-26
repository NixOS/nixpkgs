{ stdenv, fetchurl, bison, m4 }:

stdenv.mkDerivation rec {
  name = "flex-2.6.1";

  src = fetchurl {
    url = "https://github.com/westes/flex/releases/download/v2.6.1/flex-2.6.1.tar.gz";
    sha256 = "0fy14c35yz2m1n1m4f02by3501fn0cca37zn7jp8lpp4b3kgjhrw";
  };

  postPatch = ''
    patchShebangs tests
  '' + stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Makefile.in --replace "tests" " ";
  '';

  buildInputs = [ bison ];

  propagatedBuildInputs = [ m4 ];

  preConfigure = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  postConfigure = stdenv.lib.optionalString (stdenv.isDarwin || stdenv.isCygwin) ''
    sed -i Makefile -e 's/-no-undefined//;'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/westes/flex;
    description = "A fast lexical analyser generator";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
