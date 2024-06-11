{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-511FTnaVdj+MB9avyKvHe5oedkPK7iIYy5kS0eI0jeg=";
  };

  cargoHash = "sha256-uBBbTb5dsJNe2Kpw2SN/a2nJGrU+g2kkX7t3O+IRbs0=";

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
