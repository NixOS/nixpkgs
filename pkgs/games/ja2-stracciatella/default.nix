{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, makeWrapper
, cmake
, python3
, rustPlatform
, SDL2
, fltk
, lua5_3
, rapidjson
, gtest }:
let
  version = "0.19.1";
  urls = {
    miniaudio = "https://github.com/mackron/miniaudio/archive/634cdb028f340075ae8e8a1126620695688d2ac3.zip";
    sol2 = "https://github.com/ThePhD/sol2/archive/v3.2.2.zip";
    stringTheory = "https://github.com/zrax/string_theory/archive/3.1.tar.gz";
  };
  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    rev = "v${version}";
    sha256 = "sha256-yZgJQyCEPMGp8n0eE8PEnLcDHKFebJi9hflot1FxmhQ=";
  };
  libstracciatella = rustPlatform.buildRustPackage {
    pname = "libstracciatella";
    inherit version;
    src = "${src}/rust";
    cargoHash = "sha256-N59ezcshofFjK3sR2ojNPAffq8x7aAWQZZHT6fx/sm4=";

    # Required to have the Rust library read the correct environment from the wrapper
    patches = [ ./patches/extra-data-dir-rust.patch ];

    preBuild = ''
      mkdir -p $out/include/stracciatella
      export HEADER_LOCATION=$out/include/stracciatella/stracciatella.h
    '';
  };
  miniaudio = fetchurl {
    url = urls.miniaudio;
    sha256 = "1v1jwYFGB3QUx2GipWAblql98Tsrad/sgD35t7F8zok=";
  };
  stringTheory = fetchurl {
    url = urls.stringTheory;
    sha256 = "1flq26kkvx2m1yd38ldcq2k046yqw07jahms8a6614m924bmbv41";
  };
  sol2 = fetchurl {
    url = urls.sol2;
    sha256 = "oGC/QRUSSf/oLJepJf9ksNNGUCyTOPByduXNn6Rr06Q=";
  };
in
stdenv.mkDerivation {
  pname = "ja2-stracciatella";
  inherit src version;

  nativeBuildInputs = [ cmake python3 makeWrapper ];
  buildInputs = [ SDL2 fltk lua5_3 rapidjson gtest ];

  patches = [ ./patches/remove-rust-buildstep.patch ];

  cmakeFlags = [
    "-DLOCAL_LUA_LIB=OFF"
    "-DLOCAL_RAPIDJSON_LIB=OFF"
    "-DLOCAL_GTEST_LIB=OFF"
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DEXTRA_DATA_DIR=$out/share/ja2"
  ];

  preConfigure = ''
    # Use rust library built with nix
    substituteInPlace CMakeLists.txt \
      --replace lib/libstracciatella_c_api.a ${libstracciatella}/lib/libstracciatella_c_api.a \
      --replace include/stracciatella ${libstracciatella}/include/stracciatella \
      --replace bin/ja2-resource-pack ${libstracciatella}/bin/ja2-resource-pack

    # Patch dependencies that are usually loaded by url
    substituteInPlace dependencies/lib-miniaudio/getter/CMakeLists.txt.in \
      --replace ${urls.miniaudio} file://${miniaudio}
    substituteInPlace dependencies/lib-string_theory/builder/CMakeLists.txt.in \
      --replace ${urls.stringTheory} file://${stringTheory}
    substituteInPlace dependencies/lib-sol2/getter/CMakeLists.txt.in \
      --replace ${urls.sol2} file://${sol2}
  '';

  postInstall = ''
    wrapProgram $out/bin/ja2 --set EXTRA_DATA_DIR $out/share/ja2
    wrapProgram $out/bin/ja2-launcher --set EXTRA_DATA_DIR $out/share/ja2
  '';

  meta = with lib; {
    description = "Jagged Alliance 2, with community fixes";
    homepage = "https://ja2-stracciatella.github.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ romatthe ];
    platforms = platforms.linux;
  };
}
