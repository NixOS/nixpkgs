{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.10.1";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "1bl4brz5vy07lrss54glp4vfca3q8d73hyc87sqdk99f76z95b6s";
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
