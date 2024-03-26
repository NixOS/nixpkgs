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
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yDBVo3GarKvcuMX7mxdxx0SJSJ5VOX3bUx6XmYxLfq4=";
  };

  cargoHash = "sha256-DZbZ3SHGWvje0gEqlx2mdLvCR4U3Xzkp8gS9FIbxW6g=";

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
    mainProgram = "cargo-leptos";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
