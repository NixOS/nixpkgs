{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, gdal, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "t-rex";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "t-rex-tileserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QNowkQzEYLOgJ2h0yq+gShmW5WgqPF3iiSejqwrOrHo=";
  };

  cargoHash = "sha256-k10DjLJCJLqjmtEED5pwQDt3mOiey89UYC36lG+3AmM=";

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
