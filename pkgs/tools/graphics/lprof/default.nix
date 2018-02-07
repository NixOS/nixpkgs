{ stdenv, fetchurl, scons, qt3, lcms1, libtiff, vigra }:

/*  how to calibrate your monitor:
    Eg see https://wiki.archlinux.org/index.php/ICC_Profiles#Loading_ICC_Profiles
*/
stdenv.mkDerivation {
  name = "lprof-1.11.4.1";
  buildInputs = [ scons qt3 lcms1 libtiff vigra ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    export QTDIR=${qt3}
    export qt_directory=${qt3}
  '';

  src = fetchurl {
    url = mirror://sourceforge/lprof/lprof/lprof-1.11.4/lprof-1.11.4.1.tar.gz;
    sha256 = "0q8x24fm5yyvm151xrl3l03p7hvvciqnkbviprfnvlr0lyg9wsrn";
  };

  buildPhase = ''
    mkdir -p $out
    export CXX=g++

    scons PREFIX=$out SYSLIBS=1 install
  '';

  installPhase = ":";

  patches = [ ./lcms-1.17.patch  ./keep-environment.patch ];

  meta = {
    description = "Little CMS ICC profile construction set";
    homepage = https://sourceforge.net/projects/lprof;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
