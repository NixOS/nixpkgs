{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-1.7.1.1";
  
  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "055a57lv2rgr6jvb76444ywhfbg9bzc9hainyk5d4cbpb4ws3pxv";
  };

  buildInputs = [openssl];
      
  meta = {
    description = "Socat - a different replacement for netcat";
    homepage = "http://www.dest-unreach.org/socat/";
  };
}
