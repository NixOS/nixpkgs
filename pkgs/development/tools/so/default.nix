{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WAUPB4hhvroE1/8nQcgLVWgGyXcFh7qxdFg6UtQzM9A=";
  };

  cargoSha256 = "sha256-aaIzGvf+PvH8nz2BSJapi1P5gSVfXT92X62FqJ1Z2L0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  meta = with lib; {
    description = "A TUI interface to the StackExchange network";
    homepage = "https://github.com/samtay/so";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
