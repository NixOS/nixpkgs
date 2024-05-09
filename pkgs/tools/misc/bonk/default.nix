{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "bonk";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "elliot40404";
    repo = "bonk";
    rev = "v${version}";
    hash = "sha256-sAMIteNkGRqmE7BQD/TNC01K3eQQTLKuc0jcxHxtKF8=";
  };

  cargoHash = "sha256-/qBuIG5ETUWMv2iOGpW3/awuhZb35qsBAflNJv3xTUs=";

  meta = {
    description = "The blazingly fast touch alternative written in Rust";
    homepage = "https://github.com/elliot40404/bonk";
    license = lib.licenses.mit;
    mainProgram = "bonk";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
