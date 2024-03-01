{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pfetch-rs";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7Udop3542L2l9EYQZntk/qW0GUQeYfoDHQQJ8j39krQ=";
  };

  cargoHash = "sha256-gT5JjBsrGngfg77od566z+EOiH8KdARGYhTLOnOhWj4=";

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
