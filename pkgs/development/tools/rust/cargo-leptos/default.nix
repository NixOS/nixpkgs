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
  inherit (stdenv) isDarwin isLinux;
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = version;
    hash = "sha256-z4AqxvKu9E8GGMj6jNUAAWeqoE/j+6NoAEZWeNZ+1BA=";
  };

  cargoHash = "sha256-w/9W4DXbh4G5DZ8IGUz4nN3LEjHhL7HgybHqODMFzHw=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
