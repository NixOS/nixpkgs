{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.0.22";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-DRmG85lf6bBRtMfZ6AZSN4NuiOEe4NgUb+6u1tToZS4=";
  };

  cargoHash = "sha256-IBzTeJy2tO5hw4IVuVkirf5jkEXWNn0vgMKZZCvCwBI=";

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
