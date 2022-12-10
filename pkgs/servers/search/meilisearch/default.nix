{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
, nixosTests
}:

let version = "0.30.2";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    hash = "sha256-kxANzEORvR+BJDfLUD1FLorBuYjnUQixgD2jDoX6jrg=";
  };

  cargoHash = "sha256-IYNIr7PBNNloPizaauFYR9/NPnBMS8kQi+RNsKsNjLE=";

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    DiskArbitration
    Foundation
  ];

  passthru.tests = {
    meilisearch = nixosTests.meilisearch;
  };

  # Tests will try to compile with mini-dashboard features which downloads something from the internet.
  doCheck = false;

  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
  };
}
