{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pfetch-rs";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Sq5bHbUxZxgbCmekKVNlgVAXTAxY2sSPgUeFJ/nzkU4=";
  };

  cargoHash = "sha256-nEI2boe7bP/c5WKl7LifQNA2VxMvpxGeCyHcwr3aG7E=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.DisplayServices
  ];


  meta = with lib; {
    description = "Rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gobidev ];
    mainProgram = "pfetch";
  };
}
