{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, glibc
, libsoup
, cairo
, gtk3
, webkitgtk
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices Security SystemConfiguration;
in
rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "tauri-v${version}";
    hash = "sha256-XlF6OUkk9Djo28e9ntZ2EFwVyGB1nuSrCGnreSnZsRQ=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-r1lxSQAGpEXpicwuwVkQhLdMKUX36TuS5Y9MQNV28ek=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [ glibc libsoup cairo gtk3 webkitgtk ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    mainProgram = "cargo-tauri";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dit7ya happysalada ];
  };
}
