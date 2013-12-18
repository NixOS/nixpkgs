{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.7";
  
  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "0fafpbpq6jghs0fr392x525dybym9kq1s3kly2679ds526gzm2df";
  };
  
  meta = {
    homepage = http://gondor.apana.org.au/~herbert/dash/;
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
  };
}
