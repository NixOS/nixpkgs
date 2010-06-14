{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.1.2";
  
  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "0rz12l36id4sfzbr2mpral1ddcqgm71al0snh14smg8l94amnfgp";
  };

  buildInputs = [ openssl ];
      
  meta = {
    description = "Socat - a different replacement for netcat";
    homepage = "http://www.dest-unreach.org/socat/";
  };
}
