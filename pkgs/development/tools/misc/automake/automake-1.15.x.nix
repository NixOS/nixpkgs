{ lib, stdenv, fetchurl, perl, autoconf }:

stdenv.mkDerivation rec {
  pname = "automake";
  version = "1.15.1";

  src = fetchurl {
    url = "mirror://gnu/automake/automake-${version}.tar.xz";
    sha256 = "1bzd9g32dfm4rsbw93ld9x7b5nc1y6i4m6zp032qf1i28a8s6sxg";
  };

  nativeBuildInputs = [ autoconf perl ];
  buildInputs = [ autoconf ];

  setupHook = ./setup-hook.sh;

  patches = [ ./help2man-SOURCE_DATE_EPOCH-support.patch ];

  doCheck = false; # takes _a lot_ of time, fails 3 out of 2698 tests, all seem to be related to paths
  doInstallCheck = false; # runs the same thing, fails the same tests

  # The test suite can run in parallel.
  enableParallelBuilding = true;

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    branch = "1.15";
    homepage = "https://www.gnu.org/software/automake/";
    description = "GNU standard-compliant makefile generator";
    license = lib.licenses.gpl2Plus;

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    platforms = lib.platforms.all;
  };
}
