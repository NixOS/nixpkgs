{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.10";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "1arimvc9zcghhb3nin9z3yr5706vxfri4a9r3j9j9d0n676f0w5d";
  };

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://gondor.apana.org.au/~herbert/dash/;
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = {
    shellPath = "/bin/dash";
  };
}
