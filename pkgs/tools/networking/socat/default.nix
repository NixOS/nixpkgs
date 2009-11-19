{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.6.0.1";
  
  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "1cl7kf0rnbvjxz8vdkmdh1crd069qmz1jjw40r8bydgpn0nsh6qd";
  };

  buildInputs = [openssl];
      
  meta = {
    description = "Socat - a different replacement for netcat";
    homepage = "http://www.dest-unreach.org/socat/";
  };
}
