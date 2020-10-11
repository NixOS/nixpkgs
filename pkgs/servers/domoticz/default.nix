{ stdenv,
  fetchzip,
  makeWrapper,
  cmake,
  python3,
  openssl,
  pkg-config,
  mosquitto,
  lua5_3,
  sqlite,
  jsoncpp,
  zlib,
  boost,
  curl,
  git,
  libusb-compat-0_1,
  cereal
}:

let
  version = "2020.2";
  minizip = "f5282643091dc1b33546bb8d8b3c23d78fdba231";

  domoticz-src = fetchzip {
    url = "https://github.com/domoticz/domoticz/archive/${version}.tar.gz";
    sha256 = "1b4pkw9qp7f5r995vm4xdnpbwi9vxjyzbnk63bmy1xkvbhshm0g3";
  };

  minizip-src = fetchzip {
    url = "https://github.com/domoticz/minizip/archive/${minizip}.tar.gz";
    sha256 = "1vddrzm4pwl14bms91fs3mbqqjhcxrmpx9a68b6nfbs20xmpnsny";
  };
in
stdenv.mkDerivation rec {
  name = "domoticz";
  inherit version;

  src = domoticz-src;

  postUnpack = ''
    cp -r ${minizip-src}/* $sourceRoot/extern/minizip
  '';

  enableParallelBuilding = true;

  buildInputs = [
    openssl
    python3
    mosquitto
    lua5_3
    sqlite
    jsoncpp
    boost
    zlib
    curl
    git
    libusb-compat-0_1
    cereal
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_BUILTIN_MQTT=false"
    "-DUSE_BUILTIN_LUA=false"
    "-DUSE_BUILTIN_SQLITE=false"
    "-DUSE_BUILTIN_JSONCPP=false"
    "-DUSE_BUILTIN_ZLIB=false"
    "-DUSE_OPENSSL_STATIC=false"
    "-DUSE_STATIC_BOOST=false"
    "-DUSE_BUILTIN_MINIZIP=true"
  ];

  installPhase = ''
    mkdir -p $out/share/domoticz
    cp -r $src/www $out/share/domoticz/
    cp -r $src/Config $out/share/domoticz
    cp -r $src/scripts $out/share/domoticz
    cp -r $src/plugins $out/share/domoticz

    mkdir -p $out/bin
    cp domoticz $out/bin
    wrapProgram $out/bin/domoticz --set LD_LIBRARY_PATH ${python3}/lib;
  '';

  meta = with stdenv.lib; {
    description = "Home automation system";
    longDescription = ''
      Domoticz is a home automation system that lets you monitor and configure
      various devices like: lights, switches, various sensors/meters like
      temperature, rain, wind, UV, electra, gas, water and much more
    '';
    maintainers = with maintainers; [ edcragg ];
    homepage = "https://www.domoticz.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
