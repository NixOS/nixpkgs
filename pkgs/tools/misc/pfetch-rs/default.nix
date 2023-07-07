{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pfetch-rs";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q8fjFm+xANWcchCUhZdabtmcw3ACpUgqFCYzDe/XY5E=";
  };

  cargoHash = "sha256-PfOPQPjuLT4ESZHlnfZNOSeqlqskUCokA8AWGTEUkxk=";

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
  };
}
