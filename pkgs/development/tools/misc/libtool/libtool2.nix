{ stdenv, fetchurl, m4, perl, lzma }:

stdenv.mkDerivation rec {
  name = "libtool-2.2.6a";
  
  src = fetchurl {
    url = "mirror://gnu/libtool/${name}.tar.lzma";
    sha256 = "12k3m7d0ngcwwahicncxbyd1155ij63ylr8372f0q8xbzq59c8hx";
  };
  
  buildInputs = [ lzma m4 perl ];

  unpackCmd = "lzma -d < $src | tar xv";

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

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
  };
}
