{
  lib,
  stdenv,
  fetchurl,
  perl,
  autoconf,
}:

stdenv.mkDerivation rec {
  pname = "automake";
  version = "1.11.6";

  # TODO: Remove the `aclocal' wrapper when $ACLOCAL_PATH support is
  # available upstream; see
  # <https://debbugs.gnu.org/cgi/bugreport.cgi?bug=9026>.
  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/automake-${version}.tar.xz";
    sha256 = "1ffbc6cc41f0ea6c864fbe9485b981679dc5e350f6c4bc6c3512f5a4226936b5";
  };

  patches = [
    ./fix-test-autoconf-2.69.patch
    ./fix-perl-5.26.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    perl
    autoconf
  ];
  buildInputs = [ autoconf ];

  doCheck = false; # takes _a lot_ of time, fails 11 of 782 tests

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  # Run the test suite in parallel.
  enableParallelBuilding = true;

  meta = {
    branch = "1.11";
    homepage = "https://www.gnu.org/software/automake/";
    description = "GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.all;
  };
}
