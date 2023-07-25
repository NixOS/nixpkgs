{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rtz";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "rtz";
    rev = "v${version}";
    hash = "sha256-0RR6Tz9ic8ockfnMW//PQZ1XkZOD46aWgdLY4AXmBT0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bincode-2.0.0-rc.3" = "sha256-YCoTnIKqRObeyfTanjptTYeD9U2b2c+d4CJFWIiGckI=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  buildFeatures = [ "web" ];

  env = {
    # requires nightly features
    RUSTC_BOOTSTRAP = true;
  };

  meta = with lib; {
    description = "A tool to easily work with time zones via a binary, a library, or a server";
    homepage = "https://github.com/twitchax/rtz";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
