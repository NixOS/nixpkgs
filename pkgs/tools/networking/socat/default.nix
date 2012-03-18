{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.2.0";
  
  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "00hq0ia1fs4sy0qpavzlpf4qmnhh2ybq5is2kqzvqky14zlvvcsr";
  };

  buildInputs = [ openssl ];
      
  meta = {
    description = "Socat - a different replacement for netcat";
    homepage = "http://www.dest-unreach.org/socat/";
  };
}
