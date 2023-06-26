{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, git
, darwin
, makeWrapper
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices;
  pname = "tauri-mobile";
  version = "unstable-2023-06-06";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "43b2a3ba3a05b9ca3d3c9d8d7eafbeb4f24bf396";
    hash = "sha256-fVQmhtUn2Lwtr/id/qWtgnHQdXkf0jAOg4apOgnLD4Y=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "source/tooling/cli";

  cargoHash = "sha256-MtLfcDJcLVhsIGD6pjpomuu9GYGqa7L8xnaQ++f+0H4=";

  preBuild = ''
    mkdir -p $out/share/
    # during the install process tauri-mobile puts templates and commit information in CARGO_HOME
    export CARGO_HOME=$out/share/
  '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];
  nativeBuildInputs = [ pkg-config git makeWrapper ];

  preFixup = ''
    for bin in $out/bin/cargo-*; do
      wrapProgram $bin \
        --set CARGO_HOME "$out/share"
    done
  '';

  meta = with lib; {
    description = "Rust on mobile made easy! ";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
