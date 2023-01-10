{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, glibc
, libsoup
, cairo
, gtk3
, webkitgtk
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices Security;
in
rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "tauri-v${version}";
    sha256 = "sha256-4v0ZlFBVBB+0xWbTRncVwELaZWLKyCmIceTfseXvS8s=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "source/tooling/cli";

  cargoSha256 = "sha256-Hp6+T2CN0CsXaGnCVqAYaOjZNDkmI+MXDfHIgbU1S0g=";

  buildInputs = lib.optionals stdenv.isLinux [ glibc libsoup cairo gtk3 webkitgtk ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
