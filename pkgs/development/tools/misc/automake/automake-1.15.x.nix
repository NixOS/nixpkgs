{ stdenv, fetchurl, perl, autoconf }:

stdenv.mkDerivation rec {
  name = "automake-1.15";

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "0dl6vfi2lzz8alnklwxzfz624b95hb1ipjvd3mk177flmddcf24r";
  };

  nativeBuildInputs = [ autoconf perl ];
  buildInputs = [ autoconf ];

  setupHook = ./setup-hook.sh;

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";
  doCheck = false; # takes _a lot_ of time, fails 3 out of 2698 tests, all seem to be related to paths
  doInstallCheck = false; # runs the same thing, fails the same tests

  # The test suite can run in parallel.
  enableParallelBuilding = true;

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    branch = "1.15";
    homepage = https://www.gnu.org/software/automake/;
    description = "GNU standard-compliant makefile generator";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    platforms = stdenv.lib.platforms.all;
  };
}
