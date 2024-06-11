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
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "tauri-v${version}";
    hash = "sha256-6GUgxSfuy2v38lYVdjsN0vd63/Aci0ERgG2kF2E2AFA=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-HC+6AoBx51ahK6QA1Ug7jaKftkE5W3FS629uQ0yrV3Q=";

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
