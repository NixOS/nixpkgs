{ stdenv, lib, fetchurl, fetchFromGitHub, cmake, python, rustPlatform, SDL2, fltk, rapidjson, gtest, Carbon, Cocoa }:
let
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    rev = "v${version}";
    sha256 = "0m6rvgkba29jy3yq5hs1sn26mwrjl6mamqnv4plrid5fqaivhn6j";
  };
  libstracciatella = rustPlatform.buildRustPackage {
    pname = "libstracciatella";
    inherit version;
    src = "${src}/rust";
    cargoSha256 = "0blb971cv9k6c460mwq3zq8vih687bdnb39b9gph1hr90pxjviba";

    preBuild = ''
      mkdir -p $out/include/stracciatella
      export HEADER_LOCATION=$out/include/stracciatella/stracciatella.h
    '';
  };
  stringTheoryUrl = "https://github.com/zrax/string_theory/archive/3.1.tar.gz";
  stringTheory = fetchurl {
    url = stringTheoryUrl;
    sha256 = "1flq26kkvx2m1yd38ldcq2k046yqw07jahms8a6614m924bmbv41";
  };
in
stdenv.mkDerivation {
  pname = "ja2-stracciatella";
  inherit src version;

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ SDL2 fltk rapidjson gtest ] ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  patches = [
    ./remove-rust-buildstep.patch
  ];

  preConfigure = ''
    # Use rust library built with nix
    substituteInPlace CMakeLists.txt \
      --replace lib/libstracciatella_c_api.a ${libstracciatella}/lib/libstracciatella_c_api.a \
      --replace include/stracciatella ${libstracciatella}/include/stracciatella \
      --replace bin/ja2-resource-pack ${libstracciatella}/bin/ja2-resource-pack

    # Patch dependencies that are usually loaded by url
    substituteInPlace dependencies/lib-string_theory/builder/CMakeLists.txt.in \
      --replace ${stringTheoryUrl} file://${stringTheory}

    cmakeFlagsArray+=("-DLOCAL_RAPIDJSON_LIB=OFF" "-DLOCAL_GTEST_LIB=OFF" "-DEXTRA_DATA_DIR=$out/share/ja2")
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=/tmp $out/bin/ja2 -unittests
  '';

  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
  };
}
