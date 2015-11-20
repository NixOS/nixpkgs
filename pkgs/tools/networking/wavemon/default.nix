{stdenv, fetchgit, ncurses, libnl, pkgconfig}:
stdenv.mkDerivation rec {
  version = "0.7.6.20151001";
  baseName="wavemon";
  name="${baseName}-${version}";
  buildInputs = [ncurses libnl pkgconfig];
  src = fetchgit {
    url = https://github.com/uoaerg/wavemon.git ;
    rev = "05753aed2ec5a786d602c7903c89fc6a230f8d42";
    sha256 = "13y4bi4qz4596f11ng6zaqir5j234wv64z4670q3pzh3fqmzmpm4";
  };
  meta = {
    inherit version;
    description = "WiFi state monitor";
    license = stdenv.lib.licenses.gpl3Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = https://github.com/uoaerg/wavemon.git ;
  };
}
