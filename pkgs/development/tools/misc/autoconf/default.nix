{ stdenv, fetchurl, m4, perl }:

stdenv.mkDerivation rec {
  name = "autoconf-2.68";

  src = fetchurl {
    url = "mirror://gnu/autoconf/${name}.tar.bz2";
    sha256 = "1j1j8d2p3r9mzx8b2hnmfqy2683r2wyyvki6bs9cmm6n7wkzp4f4";
  };

  buildInputs = [ m4 perl ];

  # Work around a known issue in Cygwin.  See
  # http://thread.gmane.org/gmane.comp.sysutils.autoconf.bugs/6822 for
  # details.
  # There are many test failures on `i386-pc-solaris2.11'.
  doCheck = (stdenv.system != "i686-cygwin"
             && stdenv.system != "i686-solaris");

  # Don't fixup "#! /bin/sh" in Autoconf, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    homepage = http://www.gnu.org/software/autoconf/;
    description = "GNU Autoconf, a part of the GNU Build System";

    longDescription = ''
      GNU Autoconf is an extensible package of M4 macros that produce
      shell scripts to automatically configure software source code
      packages.  These scripts can adapt the packages to many kinds of
      UNIX-like systems without manual user intervention.  Autoconf
      creates a configuration script for a package from a template
      file that lists the operating system features that the package
      can use, in the form of M4 macro calls.
    '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
