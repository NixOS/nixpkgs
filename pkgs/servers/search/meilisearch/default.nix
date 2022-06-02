{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
, DiskArbitration
, Foundation
}:

let version = "0.23.1";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-4F7noByC9ZgqYwPfkm8VE15QU2jbBvUAH4Idxa+J+Aw=";
  };
  cargoPatches = [
    # feature mini-dashboard tries to download a file from the internet
    # feature analitycs should be opt-in
    ./remove-default-feature.patch
  ];
  cargoSha256 = "sha256-dz+1IQZRSeMEagI2dnOtR3A8prg4UZ2Om0pd1BUhuhE=";
  buildInputs = lib.optionals stdenv.isDarwin [ Security DiskArbitration Foundation ];
  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = "https://docs.meilisearch.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
