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
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
    rev = "v${version}";
    hash = "sha256-sNrYrV+oGvGCwVzuEoTNr1SawQUULfAsPAqjE35vjl8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-reverse-proxy-0.5.2-dev" = "sha256-R1ZXGgWvwHWRHmKX823QLqM6ZJW+tzWUXigKkAyI5OE=";
      "tokiotest-httpserver-0.2.1" = "sha256-IPUaglIDwCUoczCCnX+R1IBqtc0s8b8toKEL8zN3/i8=";
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
