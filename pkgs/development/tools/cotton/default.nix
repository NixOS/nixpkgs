{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "cotton";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = pname;
    rev = "04e2dfd123f7af6e78e3ce86b2fc04ca4c754cdc";
    sha256 = "sha256-+HOuQyGkyS7oG0I0DkFGl+6YIDpV4GCCgC+a5Jwo4fw=";
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
