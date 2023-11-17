{ darwin
, fetchFromGitHub
, lib
, openssl
, pkg-config
, rustPlatform
, stdenv
}:
let
  inherit (darwin.apple_sdk.frameworks)
    CoreServices
    Security;
  inherit (lib) optionals;
  inherit (stdenv) isDarwin;
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = "e98b478b0c82af1469151eff30f4246b9af4a539";
    hash = "sha256-7o/yQanBBSA+MmMiGCYSjar4hZ8TRZoPiUniF5ELzXU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = optionals (!isDarwin) [ pkg-config ];

  buildInputs = optionals (!isDarwin) [
    openssl
  ] ++ optionals isDarwin [
    Security
    CoreServices
  ];

  # https://github.com/leptos-rs/cargo-leptos#dependencies
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to install missing dependencies on its own otherwise
  doCheck = false; # Check phase tries to query crates.io

  meta = with lib; {
    description = "A build tool for the Leptos web framework";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
