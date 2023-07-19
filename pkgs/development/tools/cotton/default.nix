{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "cotton";
  version = "unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = pname;
    rev = "940564f64fb6cc6a4bf1e59bc2498ca19a62e1c3";
    sha256 = "sha256-SwbF+CRjcjCDMt4tCq8dWbTsnIP5tZZw4e2cThQJIdY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "node-semver-2.0.1-alpha.0" = "sha256-ldRQuJGo8gGc4fBD8E/J1aPJcwG7lg7jhwRvl/P2BbM=";
      "tokio-tar-0.3.0" = "sha256-mD6bls4rGsJhu/W56C5VYgK4mzcSJ2DPOaPAbRLStT8=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A package manager for JavaScript projects";
    homepage = "https://github.com/danielhuang/cotton";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
