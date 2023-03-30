{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YCIXpCNKqdCSvq7CSPSwoPc2gpCnnda8S7I4FzpezMc=";
  };

  cargoHash = "sha256-l6gMz/iJeLl+RLjOiR9U1m6V/rK+RWM84bQiz4jCFtY=";

  passthru = {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-4jQvlxU3S3twTpiLab8BXC6ZSPSWN6ftK3GzfKnjHSE=";
    };
  };

  meta = with lib; {
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ajs124 ];
  };
}
