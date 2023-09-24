{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "cotton";
  version = "unstable-2023-09-13";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = pname;
    rev = "df9d79a4b0bc4b140e87ddd7795924a93775a864";
    sha256 = "sha256-ZMQaVMH8cuOb4PQ19g0pAFAMwP8bR60+eWFhiXk1bYE=";
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
