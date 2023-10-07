{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fast-ssh";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "julien-r44";
    repo = "fast-ssh";
    rev = "v${version}";
    sha256 = "sha256-eHJdMe8RU6Meg/9+NCfIneD5BqNUc2yIiQ8Z5UqUBUI=";
  };

  cargoSha256 = "sha256-sIQNoH3UWX3SwCFCPZEREIFR7C28ml4oGsrq6wuOAT0=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "TUI tool to use the SSH config for connections";
    homepage = "https://github.com/julien-r44/fast-ssh";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
