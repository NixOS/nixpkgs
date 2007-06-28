{stdenv, fetchurl, static ? false}:

stdenv.mkDerivation {
  name = "device-mapper-1.02.20";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/dm/device-mapper.1.02.20.tgz;
    sha256 = "2db8a8d402b6a827c5684919b4013444cb9fad50ab8cf7ca86ade9bea7796b1c";
  };
  configureFlags = if static then "--enable-static_link" else "";
  # To prevent make install from failing.
  installFlags = "OWNER= GROUP=";
}
