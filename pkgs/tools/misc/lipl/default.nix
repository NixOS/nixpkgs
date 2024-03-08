{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "lipl";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "yxdunc";
    repo = "lipl";
    rev = "v${version}";
    hash = "sha256-ZeYz9g06vMsOk3YDmy0I+8e6BtLfweXqVH5uRt+mtes=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cmd_lib-0.7.8" = "sha256-FyJZkxhKwHyGEmeLZfcvLe1D6h7XY5tvsHbANQk+D+4=";
    };
  };

  meta = with lib; {
    description = "A command line tool to analyse the output over time of custom shell commands";
    homepage = "https://github.com/yxdunc/lipl";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lipl";
  };
}
