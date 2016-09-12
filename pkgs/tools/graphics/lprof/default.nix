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

  # The sed commands disable header checks and add LDFLAGS NIX_CFLAGS_COMPILE
  # to the gcc environment
  buildPhase = ''
    mkdir -p $out
    export CXX=g++
    sed -i  SConstruct \
     -e 's/def CheckForQt(context):/def CheckForQt(context):\n  return 1/' \
     -e "s/not config.CheckHeader('lcms.h')/False/" \
     -e "s/not config.CheckHeader('tiff.h')/False/" \
     -e "s/not config.CheckCXXHeader('vigra\/impex.hxx')/False/" \
     \
     -e "s/^\(      'LDFLAGS'.*\)/\1\n,'hardeningDisable' : os.environ['hardeningDisable']/" \
     -e "s/^\(      'LDFLAGS'.*\)/\1\n,'NIX_CFLAGS_COMPILE' : os.environ['NIX_CFLAGS_COMPILE']/" \
     -e "s/^\(      'LDFLAGS'.*\)/\1\n,'NIX_LDFLAGS' : os.environ['NIX_LDFLAGS']/"

    scons PREFIX=$out SYSLIBS=1 install
  '';

  installPhase = ":";

  patches = [ ./lcms-1.17.patch ];

  meta = {
    description = "Little CMS ICC profile construction set";
    homepage = "http://sourceforge.net/projects/lprof";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
