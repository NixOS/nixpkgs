{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
}:

let version = "0.26.1";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-PF4lWI0M8ohC/qO+mWziXlM62AykT1egeA029IpOLiE=";
  };

   cargoPatches = [
    # feature mini-dashboard tries to download a file from the internet
    # feature analitycs should be opt-in
    ./remove_default_features.patch
  ];

  cargoSha256 = "sha256-/mOyYC1HdRugBjRWyZ/zpOllgsyEAlpBl9lPOP7BHuk=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security DiskArbitration Foundation ];

  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = "https://docs.meilisearch.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
