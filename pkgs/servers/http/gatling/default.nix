{ stdenv, fetchurl, libowfat, zlib, openssl }:

let
  version = "0.15";
in
stdenv.mkDerivation rec {
  name = "gatling-${version}";

  src = fetchurl {
    url = "https://www.fefe.de/gatling/${name}.tar.xz";
    sha256 = "194srqyja3pczpbl6l169zlvx179v7ln0m6yipmhvj6hrv82k8vg";
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
