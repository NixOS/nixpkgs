{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Hr4ZC9tqrzUh+v+skyrx5xmU7dusIKoATuoNLd0tqUg=";
  };

  cargoHash = "sha256-7l9a/2jUtNg2LzGTXj//znJmeyMTuEcS1tlzoNos/jA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];

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
