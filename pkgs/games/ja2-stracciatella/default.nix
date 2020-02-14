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
    legacyCargoFetcher = true;
    cargoSha256 = "0a1pc8wyvgmna0a5cbpv3mh0h4nzjxlm887ymcq00cy1ciq5nmj4";
    doCheck = false;
  };
in
stdenv.mkDerivation {
  pname = "ja2-stracciatella";
  inherit src;
  inherit version;

  buildInputs = [ cmake SDL2 fltk boost ];

  patches = [
    ./remove-rust-buildstep.patch
  ];
  preConfigure = ''
    sed -i -e 's|rust-stracciatella|${libstracciatella}/lib/libstracciatella.so|g' CMakeLists.txt
    cmakeFlagsArray+=("-DEXTRA_DATA_DIR=$out/share/ja2")
  '';

  enableParallelBuilding = true;
  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = https://ja2-stracciatella.github.io/;
  };
}
