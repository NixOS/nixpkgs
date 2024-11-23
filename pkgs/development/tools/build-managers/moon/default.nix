{
  lib,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  stdenv,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "moon";
  version = "1.30.5";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yH/NK5i0RL71TPgPkpLJuqx7YBdFVVGTEc5Hb1uBcak=";
  };

  cargoHash = "sha256-wQ7JFccDCE7riMTsqlYI2CHMHEZVuRLgB5EwvNV4QsM=";

  env = {
    RUSTFLAGS = "-C strip=symbols";
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];
  nativeBuildInputs = [ pkg-config ];

  # Some tests fail, because test using internet connection and install NodeJS by example
  doCheck = false;

  meta = with lib; {
    description = "Task runner and repo management tool for the web ecosystem, written in Rust";
    mainProgram = "moon";
    homepage = "https://github.com/moonrepo/moon";
    license = licenses.mit;
    maintainers = with maintainers; [ flemzord ];
  };
}
