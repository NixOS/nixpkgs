{ stdenv, fetchurl, libowfat, zlib, openssl }:

let
  version = "0.13";
in
stdenv.mkDerivation rec {
  name = "gatling-${version}";

  src = fetchurl {
    url = "http://dl.fefe.de/${name}.tar.bz2";
    sha256 = "0icjx20ws8gqxgpm77dx7p9zcwi1fv162in6igx04rmnyzyla8dl";
  };

  buildInputs = [  libowfat zlib openssl.dev ];

  configurePhase = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
    substituteInPlace GNUmakefile --replace "/opt/diet" "$out"
  '';

  buildPhase = ''
    make gatling
  '';

  meta = with stdenv.lib; {
    description = "A high performance web server";
    homepage = http://www.fefe.de/gatling/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
