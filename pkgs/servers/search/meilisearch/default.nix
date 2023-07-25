{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, nixosTests
, nix-update-script
}:

let version = "1.2.0";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-j+tz47dQFyKy51UAzFOc2YkAeYDUdsiteenC38cWrLI=";
  };

  cargoBuildFlags = [
    "--package=meilisearch"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "actix-web-static-files-3.0.5" = "sha256-2BN0RzLhdykvN3ceRLkaKwSZtel2DBqZ+uz4Qut+nII=";
      "heed-0.12.5" = "sha256-WOdpgc3sDNKBSYWB102xTxmY1SWljH9Q1+6xmj4Rb8Q=";
      "lmdb-rkv-sys-0.15.1" = "sha256-zLHTprwF7aa+2jaD7dGYmOZpJYFijMTb4I3ODflNUII=";
      "nelson-0.1.0" = "sha256-eF672quU576wmZSisk7oDR7QiDafuKlSg0BTQkXnzqY=";
    };
  };

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
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
