{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o57WtzTouIzB0yl6lEUwpav0rm+jwD5tyBqK/MRN+ME=";
  };

  cargoSha256 = "sha256-flj4p4qAMMy46/nY48lRNcyB8KzEUoYOfhDk7xR7qQU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
