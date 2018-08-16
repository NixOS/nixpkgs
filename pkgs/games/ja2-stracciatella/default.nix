{ stdenv, fetchFromGitHub, cmake, SDL2, boost, fltk, rustPlatform }:
with rustPlatform;
let
  version = "0.16.1";
  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    rev = "v${version}";
    sha256 = "1pyn23syg70kiyfbs3pdlq0ixd2bxhncbamnic43rym3dmd52m29";
  };
  lockfile = ./Cargo.lock;
  libstracciatellaSrc = stdenv.mkDerivation {
    name = "libstracciatella-${version}-src";
    src = "${src}/rust";
    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${lockfile} $out/Cargo.lock
    '';
  };
  libstracciatella = buildRustPackage {
    name = "libstracciatella-${version}";
    inherit version;
    src = libstracciatellaSrc;
    cargoSha256 = "0gxp5ps1lzmrg19h6k31fgxjdnjl6amry2vmb612scxcwklxryhm";
    doCheck = false;
  };
in
stdenv.mkDerivation rec {
  name = "ja2-stracciatella-${version}";
  inherit src;
  inherit version;

  buildInputs = [ cmake SDL2 fltk boost ];

  patches = [
    ./remove-rust-buildstep.patch
  ];
  preConfigure = ''
    sed -i -e 's|rust-stracciatella|${libstracciatella}/bin/libstracciatella.so|g' CMakeLists.txt
    cmakeFlagsArray+=("-DEXTRA_DATA_DIR=$out/share/ja2")
  '';

  enableParallelBuilding = true;
  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = https://ja2-stracciatella.github.io/;
  };
}
