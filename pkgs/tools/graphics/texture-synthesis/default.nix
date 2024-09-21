{ lib, rustPlatform, fetchFromGitHub, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "texture-synthesis";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "embarkstudios";
    repo = pname;
    rev = version;
    hash = "sha256-BJa6T+qlbn7uABKIEhFhwLrw5sG/9al4L/2sbllfPFg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "img_hash-2.1.0" = "sha256-Ba26n//bZweYvb5p47U209dHrsDHKHLQ3YEHbKT+hjE=";
    };
  };

  cargoPatches = [
    # fix build with rust 1.76+
    # https://github.com/rust-lang/rust/pull/117984
    # https://github.com/rust-lang-deprecated/rustc-serialize/pull/200
    ./update-rustc-serialize.patch
  ];

  # tests fail for unknown reasons on aarch64-darwin
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = with lib; {
    description = "Example-based texture synthesis written in Rust";
    homepage = "https://github.com/embarkstudios/texture-synthesis";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "texture-synthesis";
  };
}
