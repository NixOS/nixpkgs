{ fetchurl, stdenv }:

stdenv.mkDerivation {
  name = "tcp-wrappers-7.6";

  src = fetchurl {
    url = mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_7.6.dbs.orig.tar.gz;
    sha256 = "0k68ziinx6biwar5lcb9jvv0rp6b3vmj6861n75bvrz4w1piwkdp";
  };
  
  builder = ./builder.sh;

  # meta = ...
}
