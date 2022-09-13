{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
, nixosTests
}:

let version = "0.28.1";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-AjSzzOQ1K47tyc8Zn7kAU3B1UE9Tfvd3SvP7W13m6/o=";
  };
  cargoSha256 = "sha256-zRSAjOKKmL79eXrA6/ZNE3lo8MFdOqYJkcagcA51c6M=";
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
