{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-96CfSRe6Myzk03xn+d8+d5i37g4FTYryaC+Bfn9qfL0=";
  };

  cargoHash = "sha256-EmmOI0jfd+IUFl7cU1nLkHX99u9XpaWBKy9TcEtMzYM=";

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
