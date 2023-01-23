{ lib, stdenv, fetchurl, SDL2, eigen, libepoxy, fftw, gtest, pkg-config }:

stdenv.mkDerivation rec {
  pname = "movit";
  version = "1.6.3";

  src = fetchurl {
    url = "https://movit.sesse.net/${pname}-${version}.tar.gz";
    sha256 = "164lm5sg95ca6k546zf775g3s79mgff0az96wl6hbmlrxh4z26gb";
  };

  outputs = [ "out" "dev" ];

  GTEST_DIR = "${gtest.src}/googletest";

  propagatedBuildInputs = [ eigen libepoxy ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 fftw gtest ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-performance, high-quality video filters for the GPU";
    homepage = "https://movit.sesse.net";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
