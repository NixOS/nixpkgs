{ lib, stdenv, fetchurl, perl, autoconf }:

stdenv.mkDerivation rec {
  pname = "automake";
  version = "1.16.5";

  src = fetchurl {
    url = "mirror://gnu/automake/automake-${version}.tar.xz";
    sha256 = "0sdl32qxdy7m06iggmkkvf7j520rmmgbsjzbm7fgnxwxdp6mh7gh";
  };

  strictDeps = true;
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

  meta = with lib; {
    branch = "1.16";
    homepage = "https://www.gnu.org/software/automake/";
    description = "GNU standard-compliant makefile generator";
    license = licenses.gpl2Plus;
    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';
    platforms = platforms.all;
  };
}
