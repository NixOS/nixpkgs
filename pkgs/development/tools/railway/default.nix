{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-CL75WefdcBmGSoqReHM2eecsQPcciRfat7ULhc4TfV4=";
  };

  cargoHash = "sha256-/uiz7dmuuByS99y7rXwyCtFGIR+DIenky4dusJCMFZg=";

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
