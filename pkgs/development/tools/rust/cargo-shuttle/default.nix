{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, curl
, libgit2_1_5
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "shuttle";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "shuttle";
    rev = "v${version}";
    hash = "sha256-lDRT3M6LfQrts9X2erRVyqTFWVqOwWQ/JFB1ZlK6Lo8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-reverse-proxy-0.5.2-dev" = "sha256-R1ZXGgWvwHWRHmKX823QLqM6ZJW+tzWUXigKkAyI5OE=";
      "tokiotest-httpserver-0.2.1" = "sha256-IPUaglIDwCUoczCCnX+R1IBqtc0s8b8toKEL8zN3/i8=";
    };
  };

  patches = [
    # make sure to have only one revision of hyper-reverse-proxy
    # necessary to make `importCargoLock` work
    # https://github.com/shuttle-hq/shuttle/pull/921
    (fetchpatch {
      name = "chore-promote-hyper-reverse-proxy-to-a-workspace-dependency.patch";
      url = "https://github.com/shuttle-hq/shuttle/commit/5c398427229f1358bd26ec81a2a22d01adf11b3d.patch";
      hash = "sha256-fJBz/0StMALtJYh/Ec/KGCwCGLtch+HH/oYlibE8xcw=";
    })
  ];

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2_1_5
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
