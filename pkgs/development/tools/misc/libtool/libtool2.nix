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
}
