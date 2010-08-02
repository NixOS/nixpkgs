{ stdenv, fetchurl, autoconf, automake }:

stdenv.mkDerivation {
  name = "bridge-utils-1.2";

  src = fetchurl {
    url = mirror://sourceforge/bridge/bridge-utils-1.2.tar.gz;
    sha256 = "0jg3z51c2c34byg4zi39j9g4b66js5kanjhid77hpa0jdfmryfy9";
  };

  buildInputs = [ autoconf automake ];

  preConfigure = "autoreconf";

  meta = { 
    description = "http://sourceforge.net/projects/bridge/";
    homepage = [ "http://www.linux-foundation.org/en/Net:Bridge/" "http://sourceforge.net/projects/bridge/" ];
    license = "GPL";
  };
}
