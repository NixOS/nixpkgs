{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, gdal, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "t-rex";
  version = "0.14.3-beta4";

  src = fetchFromGitHub {
    owner = "t-rex-tileserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EG/nnHxnBwlxreJ+RWHvKqLpaVtlU95+YTJynEnypOE=";

  };

  cargoHash = "sha256-noDZNFZlfX6lZ4czsSrHXe7xbBLTD0Gz8i5EyfEp8lc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gdal openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Vector tile server specialized on publishing MVT tiles";
    homepage = "https://t-rex.tileserver.ch/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
