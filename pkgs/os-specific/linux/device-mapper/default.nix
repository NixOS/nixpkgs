{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "device-mapper-1.02.13";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/dm/device-mapper.1.02.13.tgz;
    md5 = "9ab13083a939ceb26ce5da6b625aeb3c";
  };
  # To prevent make install from failing.
  installFlags = "OWNER= GROUP=";
}
