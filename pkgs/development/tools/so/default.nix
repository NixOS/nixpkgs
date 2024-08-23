{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-25jZEo1C9XF4m9YzDwtecQy468nHyv2wnRuK5oY2siU=";
  };

  cargoHash = "sha256-F9DNY0jKhH6aQRqlXq6MEMoFa1qtvAdL5lSEsql6gcI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  meta = with lib; {
    description = "TUI interface to the StackExchange network";
    mainProgram = "so";
    homepage = "https://github.com/samtay/so";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
