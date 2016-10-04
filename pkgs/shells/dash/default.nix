{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.8";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "03y6z8akj72swa6f42h2dhq3p09xasbi6xia70h2vc27fwikmny6";
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
