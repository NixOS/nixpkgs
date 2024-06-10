{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4IZNOclQj3ZLE6WRddn99CrV8OoyfkRBXnA4oEyMxv8=";
  };

  cargoSha256 = "sha256-hHXA/n/HQeBaD4QZ2b6Okw66poBRwNTpQWF0qBhLp/o=";

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
