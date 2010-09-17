{ stdenv, fetchurl, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "bridge-utils-1.4";

  src = fetchurl {
    url = "mirror://sourceforge/bridge/${name}.tar.gz";
    sha256 = "0csrvpjx1n5fzscdrc0xky3rnaxi90rylqciha5sl0n3pklpasc7";
  };

  buildInputs = [ autoconf automake ];

  preConfigure = "autoreconf";

  meta = { 
    description = "http://sourceforge.net/projects/bridge/";
    homepage = [ "http://www.linux-foundation.org/en/Net:Bridge/" "http://sourceforge.net/projects/bridge/" ];
    license = "GPL";
  };
}
