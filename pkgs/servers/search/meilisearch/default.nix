{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, SystemConfiguration
, nixosTests
, nix-update-script
}:

let version = "1.6.0";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-B1psJeGWG0E5oPu+OVAxkdJNblqaBzB/CurpLxdESB8=";
  };

  cargoBuildFlags = [
    "--package=meilisearch"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "actix-web-static-files-3.0.5" = "sha256-2BN0RzLhdykvN3ceRLkaKwSZtel2DBqZ+uz4Qut+nII=";
      "arroy-0.1.0" = "sha256-ybKdB0eP8AdxLMNM7Si9onWITNc2SPNTXMgKdWdy34E=";
      "candle-core-0.3.1" = "sha256-KlkjTUcbnP+uZoA0fDZlEPT5qKC2ogMAuR8X14xRFgA=";
      "hf-hub-0.3.2" = "sha256-tsn76b+/HRvPnZ7cWd8SBcEdnMPtjUEIRJipOJUbz54=";
      "nelson-0.1.0" = "sha256-eF672quU576wmZSisk7oDR7QiDafuKlSg0BTQkXnzqY=";
      "tokenizers-0.14.1" = "sha256-cq7dQLttNkV5UUhXujxKKMuzhD7hz+zTTKxUKlvz1s0=";
    };
  };

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security SystemConfiguration
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
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "aarch64-linux" "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
  };
}
