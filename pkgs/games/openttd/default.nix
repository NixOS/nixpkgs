{stdenv, fetchurl, pkgconfig, SDL, libpng, zlib, xz, freetype, fontconfig}:

stdenv.mkDerivation rec {
  name = "openttd-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "http://binaries.openttd.org/releases/${version}/${name}-source.tar.xz";
    sha256 = "158znfx389bhs9gd2hadnbc2a32z4ma1vz8704cmw9yh0fmhbcap";
  };

  buildInputs = [SDL libpng pkgconfig xz zlib freetype fontconfig];
  prefixKey = "--prefix-dir=";

  configureFlags = ''
    --with-zlib=${zlib}/lib/libz.a 
    --without-liblzo2
  '';

  makeFlags = "INSTALL_PERSONAL_DIR=";

  postInstall = ''
    mv $out/games/ $out/bin
  '';

  meta = {
    description = ''OpenTTD is an open source clone of the Microprose game "Transport Tycoon Deluxe".'';
    homepage = http://www.openttd.org/;
    license = "GPLv2";
  };
}
