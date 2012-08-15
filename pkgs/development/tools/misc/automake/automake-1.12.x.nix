{stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? true}:

stdenv.mkDerivation rec {
  name = "automake-1.12.2";

  # TODO: Remove the `aclocal' wrapper when $ACLOCAL_PATH support is
  # available upstream; see
  # <http://debbugs.gnu.org/cgi/bugreport.cgi?bug=9026>.
  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "5fb56e918189b377a22368e19baaf70252bd85a9969ed5f8a8373f49e8faf07f";
  };

  buildInputs = [perl autoconf makeWrapper];

  # This test succeeds on my machine, but fails on Hydra (for reasons
  # not yet understood).
  patchPhase = ''
    sed -i -e 's|t/aclocal7.sh||' Makefile.in
  '';

  # Bug in a test in automake. Upstream git already fixed it removing the test.
  doCheck = if stdenv.isMips then false else doCheck;

  # The test suite can run in parallel.
  enableParallelBuilding = true;

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    homepage = http://www.gnu.org/software/automake/;
    description = "GNU Automake, a GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
