{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ghostie";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "attriaayush";
    repo = "ghostie";
    rev = "v${version}";
    sha256 = "sha256-lEjJLmBA3dlIVxc8E+UvR7u154QGeCfEbxdgUxAS3Cw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clokwerk-0.4.0-rc1" = "sha256-GQDWEN2arDDRu2ft8QYdXsNhBEIhBNZTnLoLy27cbAI=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
    ];

  # 4 out of 5 tests are notification tests which do not work in nix builds
  doCheck = false;

  preBuild = lib.optionalString stdenv.isDarwin ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Github notifications in your terminal";
    homepage = "https://github.com/attriaayush/ghostie";
    changelog = "https://github.com/attriaayush/ghostie/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    broken = stdenv.isx86_64 && stdenv.isDarwin;
    mainProgram = "ghostie";
  };
}
