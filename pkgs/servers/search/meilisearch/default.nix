{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
, nixosTests
}:

let version = "0.29.0";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-/B44rqw4oilR7w2GnJ5LYFIWh9qv2N5Bwa+ZCgugTpQ=";
  };
  cargoSha256 = "sha256-70Nn2yvIM05K1TWh4umbh0ZHkrjPFogQ4DfCjQmgOcM=";
  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;
  buildInputs = lib.optionals stdenv.isDarwin [ Security DiskArbitration Foundation ];
  passthru.tests = {
    meilisearch = nixosTests.meilisearch;
  };

  # Tests will try to compile with mini-dashboard features which downloads something from the internet.
  doCheck = false;

  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = "https://docs.meilisearch.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
  };
}
