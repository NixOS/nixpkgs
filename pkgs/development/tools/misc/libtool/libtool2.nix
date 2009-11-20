{ stdenv, fetchurl, m4, perl, lzma }:

stdenv.mkDerivation rec {
  name = "libtool-2.2.6b";

  src = fetchurl {
    url = "mirror://gnu/libtool/${name}.tar.lzma";
    sha256 = "1bmpp31sfjl3nzj8psvnsqrrv4gwnqzii8dxpxr6djz508yavsv6";
  };

  buildNativeInputs = [ lzma m4 perl ];

  unpackCmd = "lzma -d < $src | tar xv";

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  # XXX: The GNU ld wrapper does all sorts of nasty things wrt. RPATH, which
  # leads to the failure of a number of tests.
  doCheck = false;

  meta = {
    description = "GNU Libtool, a generic library support script";

    longDescription = ''
      GNU libtool is a generic library support script.  Libtool hides
      the complexity of using shared libraries behind a consistent,
      portable interface.

      To use libtool, add the new generic library building commands to
      your Makefile, Makefile.in, or Makefile.am.  See the
      documentation for details.
    '';

    homepage = http://www.gnu.org/software/libtool/;

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
