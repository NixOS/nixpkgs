{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  Security,
  SystemConfiguration,
  nixosTests,
  nix-update-script,
}:

let
  version = "1.7.6";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-LsJM7zkoiu5LZb/rhnZaAS/wVNH8b6YZ+vNEE1wVIIk=";
  };

  cargoBuildFlags = [
    "--package=meilisearch"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "actix-web-static-files-3.0.5" = "sha256-2BN0RzLhdykvN3ceRLkaKwSZtel2DBqZ+uz4Qut+nII=";
      "candle-core-0.3.3" = "sha256-umWvG+82B793PQtY9VeHjPTtTVmSPdts25buw4v4TQc=";
      "candle-kernels-0.3.1" = "sha256-KlkjTUcbnP+uZoA0fDZlEPT5qKC2ogMAuR8X14xRFgA=";
      "hf-hub-0.3.2" = "sha256-tsn76b+/HRvPnZ7cWd8SBcEdnMPtjUEIRJipOJUbz54=";
      "tokenizers-0.14.1" = "sha256-cq7dQLttNkV5UUhXujxKKMuzhD7hz+zTTKxUKlvz1s0=";
    };
  };

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      meilisearch = nixosTests.meilisearch;
    };
  };

  # Tests will try to compile with mini-dashboard features which downloads something from the internet.
  doCheck = false;

  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine";
    mainProgram = "meilisearch";
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
