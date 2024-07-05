{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "3.9.3";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-8K+awKsSQotPqVJg7SkpPCjenU6a/cqEZogqwQAe0I8=";
  };

  cargoHash = "sha256-2KNSPn0zrx5zwF9g29x3/L/ptza+NstBu4Lc1PR4ymE=";

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
