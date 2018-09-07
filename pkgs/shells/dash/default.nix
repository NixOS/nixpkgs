{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.10.2";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "0wb0bwmqc661hylqcfdp7l7x12myw3vpqk513ncyqrjwvhckjriw";
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
