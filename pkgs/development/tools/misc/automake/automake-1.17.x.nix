{
  lib,
  stdenv,
  fetchurl,
  perl,
  autoconf,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation rec {
  pname = "automake";
  version = "1.17";

  src = fetchurl {
    url = "mirror://gnu/automake/automake-${version}.tar.xz";
    hash = "sha256-iSDB/EEeE7kL9wTvnbbynVQOdtIyyzssn03EzFmb2ZA=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    autoconf
    perl
  ];
  buildInputs = [ autoconf ];

  setupHook = ./setup-hook.sh;

  doCheck = false; # takes _a lot_ of time, fails 3 out of 2698 tests, all seem to be related to paths
  doInstallCheck = false; # runs the same thing, fails the same tests

  # The test suite can run in parallel.
  enableParallelBuilding = true;

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = with lib; {
    branch = "1.17";
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
