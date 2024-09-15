{ lib
, rustPlatform
, fetchFromGitHub
, darwin
, stdenv
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "moon";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RqL7C+0AZ9iqJ8j09ToGE7gWItMM0c2qf99yh4SPQj4=";
  };

  cargoHash = "sha256-1chIr0cAUrXR4cfzSBq0omKcizHb8nL6lcdeNaRKGdU=";

  env = {
    RUSTFLAGS = "-C strip=symbols";
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [
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
