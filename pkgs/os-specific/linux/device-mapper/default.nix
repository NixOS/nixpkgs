{stdenv, fetchurl, static ? false}:

stdenv.mkDerivation {
  name = "device-mapper-1.02.22";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/dm/device-mapper.1.02.22.tgz;
    sha256 = "158mnspws143wrgrx4h81z3gn7vzb7b2ysgmngsqcri4srn3m0zz";
  };
  configureFlags = if static then "--enable-static_link" else "";
  # To prevent make install from failing.
  installFlags = "OWNER= GROUP=";
}
