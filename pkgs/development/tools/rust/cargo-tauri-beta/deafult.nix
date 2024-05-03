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
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    rev = "tauri-v2.0.0-beta.17";
    hash = "sha256-M+L8R4DIiWBVYFSBYc6rcsxEqJipDfK0R5KqSTldQjE";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-45R8oyWwI1rgclhC7jehZQrDEPanJPqLSpg0v6TimQo=";

  nativeBuildInputs = [ 
	    pkg-config
	  ];
	
	  buildInputs = [ 
	    openssl
	  ] 
	  ++ lib.optionals stdenv.isLinux [ 
	    glibc libsoup cairo gtk3 webkitgtk 
	  ]
	  ++ lib.optionals stdenv.isDarwin [ 
	    CoreServices 
	    Security 
	    SystemConfiguration 
	  ];
	  
	  strictDeps = true;

  meta = {
	    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
	    homepage = "https://tauri.app/";
	    license = with lib.licenses; [ asl20 /* or */ mit ];
	    mainProgram = "cargo-tauri-beta";
	    maintainers = with lib.maintainers; [ dit7ya happysalada ];
	  };
	}