{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  CoreServices,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-a3d1FtcXSLL8peveBagTEF6EcNADNDhnLAmyCfTW4+4=";
  };

  cargoHash = "sha256-fwraQd7dOamhc3Tp3yLxASWCVhDOxj4vX7oTTOufkeY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      CoreServices
      Security
    ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Crafter
      techknowlogick
    ];
  };
}
