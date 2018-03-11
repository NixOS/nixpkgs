{ stdenv, fetchurl, m4, perl }:

stdenv.mkDerivation rec {
  name = "autoconf-2.69";

  src = fetchurl {
    url = "mirror://gnu/autoconf/${name}.tar.xz";
    sha256 = "113nlmidxy9kjr45kg9x3ngar4951mvag1js2a3j8nxcz34wxsv4";
  };

  nativeBuildInputs = [ m4 perl ];
  buildInputs = [ m4 ];

  # Work around a known issue in Cygwin.  See
  # http://thread.gmane.org/gmane.comp.sysutils.autoconf.bugs/6822 for
  # details.
  # There are many test failures on `i386-pc-solaris2.11'.
  #doCheck = ((!stdenv.isCygwin) && (!stdenv.isSunOS));
  doCheck = false;

  # Don't fixup "#! /bin/sh" in Autoconf, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  enableParallelBuilding = true;

  preCheck =
    # Make the Autotest test suite run in parallel.
    '' export TESTSUITEFLAGS="-j$NIX_BUILD_CORES"
    '';

  meta = {
    homepage = http://www.gnu.org/software/autoconf/;
    description = "Part of the GNU Build System";

    longDescription = ''
      GNU Autoconf is an extensible package of M4 macros that produce
      shell scripts to automatically configure software source code
      packages.  These scripts can adapt the packages to many kinds of
      UNIX-like systems without manual user intervention.  Autoconf
      creates a configuration script for a package from a template
      file that lists the operating system features that the package
      can use, in the form of M4 macro calls.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
