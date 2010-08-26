{ stdenv, fetchurl, neon, zlib, openssl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "sitecopy-0.16.6";

  src = fetchurl {
    url = "http://www.manyfish.co.uk/sitecopy/${name}.tar.gz";
    sha256 = "1bsqfhfq83g1qambqf8i1ivvggz5d2byg94hmrpxqkg50yhdsvz0";
  };

  patches = [ ./neon-29.patch ];

  preConfigure = "autoreconf";

  buildInputs = [ openssl neon zlib autoconf automake libtool ]; 

  configureFlags= "--with-ssl=openssl"; 
}
