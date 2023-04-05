{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.0.19";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-a7xrDd92/4ZRT768hOCcVzlevluGyQVTLdTfdLNQ8WI=";
  };

  cargoHash = "sha256-PuJzy0vw7yC4GctqTeAAB8Vhs8hJYXAptLr7rw69DZE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Crafter techknowlogick ];
  };
}
