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
  version = "unstable-2023-04-25";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "c2abaf54135bf65b1165a38d3b1d84e8d57f5d6c";
    sha256 = "sha256-WHyiswe64tkNhhgmHquv9YPLQAU1yTJ/KglTqEPBcOM=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  # sourceRoot = "source/tooling/cli";

  cargoHash = "sha256-Kc1BikwUYSpPShRtAPbHCdfVzo6zwjiO3QeqRkO+WhY=";

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];
  nativeBuildInputs = [ pkg-config git makeWrapper ];

  preInstall = ''
    mkdir -p $out/share/
    # the directory created in the build process is .tauri-mobile, a hidden directory
    shopt -s dotglob
    for temp_dir in $HOME/*; do
      cp -R $temp_dir $out/share
    done
  '';

  meta = with lib; {
    description = "Rust on mobile made easy! ";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
