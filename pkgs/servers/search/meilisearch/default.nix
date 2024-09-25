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
  version = "1.9.0";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meiliSearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-fPXhayS8OKiiiDvVvBry3njZ74/W6oVL0p85Z5qf3KA==";
  };

  cargoPatches = [
    # fix build with Rust 1.80
    ./time-crate.patch
  ];

  cargoBuildFlags = [ "--package=meilisearch" ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hf-hub-0.3.2" = "sha256-tsn76b+/HRvPnZ7cWd8SBcEdnMPtjUEIRJipOJUbz54=";
      "tokenizers-0.15.2" = "sha256-lWvCu2hDJFzK6IUBJ4yeL4eZkOA08LHEMfiKXVvkog8=";
    };
  };

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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

  meta = {
    description = "Powerful, fast, and an easy to use search engine";
    mainProgram = "meilisearch";
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
