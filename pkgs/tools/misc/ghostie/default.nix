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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "attriaayush";
    repo = "ghostie";
    rev = "v${version}";
    sha256 = "sha256-kdDdKI4nJqomA2h370JT180qQ+EkcLaF4NAG+PjydGE=";
  };

  cargoHash = "sha256-NI4V3j92OqBk99lDe6hJgaHmGRdEle7prayo2uGF7CE=";

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

