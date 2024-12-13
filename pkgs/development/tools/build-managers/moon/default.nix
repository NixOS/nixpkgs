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
  version = "1.29.4";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/EaRryWuH5BPm6bv8KWfLewS/8W6nUspBjvNnFq/sUQ=";
  };

  cargoHash = "sha256-m5+8WHWpOTF2vIg4ctLPC5m9F+MGRofoEAHGv1ejQXA=";

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
