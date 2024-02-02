{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bN9gI+tvMN/9Wbra4GKGc0s91JSOaNDzE5ZoOB9cgNU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoHash = "sha256-Pvjkuuh1nBAxVcFS6lWkkgQkSCgwFm2HYdaAh7I+Qrs=";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
