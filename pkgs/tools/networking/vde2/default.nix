{ stdenv, fetchurl, openssl, libpcap }:

stdenv.mkDerivation rec {
  name = "vde2-2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/vde/vde2/2.3.1/${name}.tar.gz";
    sha256 = "1vbrds8k1cn1fgvpkg2ck2227l5yy2f0qxk44sg3vymq0aiw8y37";
  };

  buildInputs = [ openssl libpcap ];

  meta = {
    homepage = http://vde.sourceforge.net/;
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
  };
}
