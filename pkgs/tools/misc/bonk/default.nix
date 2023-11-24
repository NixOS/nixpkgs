{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "bonk";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "elliot40404";
    repo = "bonk";
    rev = "v${version}";
    hash = "sha256-Y6Hia+B7kIvdvpuZwWGJBsn+pOBmMynXai4KWkNs4ck=";
  };

  cargoHash = "sha256-XphSjB49zFB3zXYpdjjcVRdTAW2Bvg91aZkxDLvFy3M=";

  meta = {
    description = "The blazingly fast touch alternative written in Rust";
    homepage = "https://github.com/elliot40404/bonk";
    license = lib.licenses.mit;
    mainProgram = "bonk";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
