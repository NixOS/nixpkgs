{ fetchFromGitHub
, lib
, stdenv
, cmake
, pkg-config
, apacheHttpd
, apr
, aprutil
, boost
, cairo
, curl
, glib
, gtk2
, harfbuzz
, icu
, iniparser
, libmemcached
, mapnik
}:

stdenv.mkDerivation rec {
  pname = "mod_tile";
  version = "0.6.1+unstable=2023-03-09";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    rev = "f521540df1003bb000d7367a59ad612161eab0f0";
    sha256 = "sha256-jIqeplAQt4W97PNKm6ZDGPDUc/PEiLM5yEdPeI+H03A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    apr
    aprutil
    boost
    cairo
    curl
    glib
    harfbuzz
    icu
    iniparser
    libmemcached
    mapnik
  ];

  # the install script wants to install mod_tile.so into apache's modules dir
  postPatch = ''
    sed -i "s|\''${HTTPD_MODULES_DIR}|$out/modules|" CMakeLists.txt
  '';

  enableParallelBuilding = true;

  # We need to either disable the `render_speedtest` and `download_tile` tests
  # or fix the URLs they try to download from
  #cmakeFlags = [ "-DENABLE_TESTS=1" ];
  #doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jglukasik ];
    platforms = platforms.linux;
  };
}
