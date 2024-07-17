{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "texture-synthesis";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "embarkstudios";
    repo = pname;
    rev = version;
    sha256 = "0n1wbxcnxb7x5xwakxdzq7kg1fn0c48i520j03p7wvm5x97vm5h4";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "img_hash-2.1.0" = "sha256-Ba26n//bZweYvb5p47U209dHrsDHKHLQ3YEHbKT+hjE=";
    };
  };

  # tests fail for unknown reasons on aarch64-darwin
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = with lib; {
    description = "Example-based texture synthesis written in Rust";
    homepage = "https://github.com/embarkstudios/texture-synthesis";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "texture-synthesis";
  };
}
