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
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hZevu2lwyYFenABu1uV7/mZc7SXfLzR6Pdmc3zHJ2vw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "leptos_hot_reload-0.3.0" = "sha256-Pl3nZaz5r5ZFagytLMczIyXEWQ6AFLb3+TrI/6Sevig=";
    };
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
