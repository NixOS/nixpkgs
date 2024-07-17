{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pfetch-rs";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tpJk31Z7QzZNLmEv/L1008tf6hpJJI6b7E1o/kwbJe0=";
  };

  cargoHash = "sha256-CQVPEUpblypDyr48MrLY3roGunOxem0eM1OtbcKlnsw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.DisplayServices
  ];

  meta = with lib; {
    description = "A rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gobidev ];
    mainProgram = "pfetch";
  };
}
