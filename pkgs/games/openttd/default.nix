{stdenv, fetchurl, SDL, libpng, zlib}:

stdenv.mkDerivation rec {
  name = "openttd-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://sf/openttd/${name}-source.tar.bz2";
    md5 = "dcf63687c73ff56887049fedaf6c6019";
  };

  buildInputs = [SDL libpng];
  prefixKey = "--prefix-dir=";
  configureFlags = "--with-zlib=${zlib}/lib/libz.a";
  makeFlags = "INSTALL_PERSONAL_DIR=";

  meta = {
    description = ''OpenTTD is an open source clone of the Microprose game "Transport Tycoon Deluxe".'';
    homepage = http://www.openttd.org/;
    license = "GPLv2";
  };
}
