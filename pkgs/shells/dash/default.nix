{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.9.1";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "5ecd5bea72a93ed10eb15a1be9951dd51b52e5da1d4a7ae020efd9826b49e659";
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
