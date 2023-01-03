{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, sqlite
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ghostie";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "attriaayush";
    repo = "ghostie";
    rev = "v${version}";
    sha256 = "sha256-O05PJa4YFD8+9BOojS7Ti1OYGxaROFKyGT9VJf5V58U=";
  };

  cargoSha256 = "sha256-YF808suqfeM156KkRGCCtGFsCdgQ4eu6n2P6yAVV7qc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
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
  };
}

