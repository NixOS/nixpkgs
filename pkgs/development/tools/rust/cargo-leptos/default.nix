{ darwin
, fetchFromGitHub
, lib
, pkg-config
, rustPlatform
, stdenv
}:
let
  inherit (darwin.apple_sdk.frameworks)
    CoreServices
    SystemConfiguration
    Security;
  inherit (lib) optionals;
  inherit (stdenv) isDarwin;
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ojLAdudgset/5ynOoue8oJ5L3Z43GHDQBf0xnpkKDOg=";
  };

  cargoHash = "sha256-OjA1M/PcMxQ7MvBf6hIn+TSCnFvIwQ+08xPcY+jWs9s=";

  buildInputs = optionals isDarwin [
    SystemConfiguration
    Security
    CoreServices
  ];

  # https://github.com/leptos-rs/cargo-leptos#dependencies
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to install missing dependencies on its own otherwise
  doCheck = false; # Check phase tries to query crates.io

  meta = with lib; {
    description = "A build tool for the Leptos web framework";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
