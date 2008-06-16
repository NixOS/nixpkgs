{stdenv, fetchurl, static ? false}:

stdenv.mkDerivation {
  name = "device-mapper-1.02.26";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/dm/device-mapper.1.02.26.tgz;
    sha256 = "0x905frw06s6k5p1rlc2hbgaphgalinarbdg82664sri0qmbkrfv";
  };
  configureFlags = if static then "--enable-static_link" else "";
  # To prevent make install from failing.
  installFlags = "OWNER= GROUP=";
}
