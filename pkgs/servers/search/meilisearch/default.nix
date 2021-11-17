{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
}:

let version = "0.24.0";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-0peKFNB/w8FDowiRo3v/dakxUSPnKbZi0ZA5ALoEzHQ=";
  };
  cargoSha256 = "sha256-U9bIXDtE71vydfSyZDznQrRsYYny/jXo97gb2CAoXy4=";
  cargoPatches = [
    # feature mini-dashboard tries to download a file from the internet
    # feature analitycs should be opt-in
    ./remove-default-feature.patch
  ];
  cargoBuildFlags = [ "--no-default-features" ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security DiskArbitration Foundation ];
  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = "https://docs.meilisearch.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
