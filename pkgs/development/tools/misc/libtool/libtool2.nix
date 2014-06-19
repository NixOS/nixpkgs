{ stdenv, fetchurl, m4, perl, lzma }:

stdenv.mkDerivation (rec {
  name = "libtool-2.4.2";

  src = fetchurl {
    url = "mirror://gnu/libtool/${name}.tar.gz";
    sha256 = "0649qfpzkswgcj9vqkkr9rn4nlcx80faxpyqscy2k1x9c94f93dk";
  };

  nativeBuildInputs = [ lzma m4 perl ];

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

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}

//

# Don't run the native `strip' when cross-compiling.  This breaks at least
# with `.a' files for MinGW.
(if (stdenv ? cross)
 then { dontStrip = true; }
 else { }))
