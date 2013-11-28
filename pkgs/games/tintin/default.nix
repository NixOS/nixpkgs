{ stdenv, fetchurl, zlib, pcre }:

stdenv.mkDerivation rec {
  name = "tintin-2.00.9";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/${name}.tar.gz";
    sha256 = "0x8jakxx7hh7b0z6vjcxyrda0afbz2s2yy7mvrbxjffyc2dyxzna";
  };

  buildInputs = [ zlib pcre ];

  preConfigure = ''
    cd src
  '';
}
