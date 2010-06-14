{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.6";
  
  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "0qnqx14y70ay1mn0w0hrknpll9266pvj0426k8niww9s7fzv89w5";
  };
  
  meta = {
    homepage = http://gondor.apana.org.au/~herbert/dash/;
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
  };
}
