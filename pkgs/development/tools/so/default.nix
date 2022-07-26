{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KiIffq8olpNpynmV4lwdY0yu2ch4MAwp5VspfLZtkf4=";
  };

  cargoSha256 = "sha256-VBuWKit50cSHYg7WzUP5ein3MEoZN/KFfm+YEEu544Q=";

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
