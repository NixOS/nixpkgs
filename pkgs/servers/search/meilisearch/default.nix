{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
}:

let version = "0.26.0";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-APqB1y+sf+ZlLmOhay6pTl2lxQPlEAAwJK5l6yc90FM=";
  };
  cargoSha256 = "sha256-oH9vXaLm4uIkagPj2FoHD0cQF+hCvbLb/aDbDu4AsmI=";
  # default features include tracking and a dashboard that downloads a binary off the internet
  cargoBuildNoDefaultFeatures = true;
  buildInputs = lib.optionals stdenv.isDarwin [ Security DiskArbitration Foundation ];
  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = "https://docs.meilisearch.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
