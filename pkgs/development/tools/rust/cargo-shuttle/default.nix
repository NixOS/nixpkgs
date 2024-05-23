{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-shuttle";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
    rev = "v${version}";
    hash = "sha256-bjGyLfeo11Y55WqPwcUxnNkexozlxC61/rSa65gBGZ4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async-posthog-0.2.3" = "sha256-V0f9+UKZkqh80p7UjINEbAW9y8cKBmJTRjAJZV3no1M=";
      "hyper-reverse-proxy-0.5.2-dev" = "sha256-R1ZXGgWvwHWRHmKX823QLqM6ZJW+tzWUXigKkAyI5OE=";
      "permit-client-rs-2.0.0" = "sha256-MxsgqPbvWDYDOb3oGuD1I6d3cdcGAhfoWsI7cwfhrb4=";
      "permit-pdp-client-rs-0.2.0" = "sha256-F9wSvo3WzoRXjZb+We0Bvcwx3rRSG1QxXPsvrmtIN38=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  cargoBuildFlags = [ "-p" "cargo-shuttle" ];

  cargoTestFlags = cargoBuildFlags ++ [
    # other tests are failing for different reasons
    "init::shuttle_init_tests::"
  ];

  meta = with lib; {
    description = "A cargo command for the shuttle platform";
    homepage = "https://shuttle.rs";
    changelog = "https://github.com/shuttle-hq/shuttle/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
