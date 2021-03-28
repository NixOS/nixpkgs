{ stdenv, fetchFromGitHub, cmake, SDL2, boost, fltk, rustPlatform }:
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
  libstracciatella = rustPlatform.buildRustPackage {
    pname = "libstracciatella";
    inherit version;
    src = libstracciatellaSrc;
    cargoSha256 = "15djs4xaz4y1hpfyfqxdgdasxr0b5idy9i5a7c8cmh0jkxjv8bqc";
    doCheck = false;
  };
in
stdenv.mkDerivation {
  pname = "ja2-stracciatella";
  inherit src;
  inherit version;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 fltk boost ];

  patches = [
    ./remove-rust-buildstep.patch
  ];

  preConfigure = ''
    sed -i -e 's|rust-stracciatella|${libstracciatella}/lib/libstracciatella.so|g' CMakeLists.txt
    cmakeFlagsArray+=("-DEXTRA_DATA_DIR=$out/share/ja2")
  '';

  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
  };
}
