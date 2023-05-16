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
<<<<<<< HEAD
  version = "unstable-2023-06-06";
=======
  version = "unstable-2023-04-25";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
<<<<<<< HEAD
    rev = "43b2a3ba3a05b9ca3d3c9d8d7eafbeb4f24bf396";
    hash = "sha256-fVQmhtUn2Lwtr/id/qWtgnHQdXkf0jAOg4apOgnLD4Y=";
=======
    rev = "c2abaf54135bf65b1165a38d3b1d84e8d57f5d6c";
    sha256 = "sha256-WHyiswe64tkNhhgmHquv9YPLQAU1yTJ/KglTqEPBcOM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
<<<<<<< HEAD
  # sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-MtLfcDJcLVhsIGD6pjpomuu9GYGqa7L8xnaQ++f+0H4=";

  preBuild = ''
    mkdir -p $out/share/
    # during the install process tauri-mobile puts templates and commit information in CARGO_HOME
    export CARGO_HOME=$out/share/
=======
  # sourceRoot = "source/tooling/cli";

  cargoHash = "sha256-Kc1BikwUYSpPShRtAPbHCdfVzo6zwjiO3QeqRkO+WhY=";

  preBuild = ''
    export HOME=$(mktemp -d)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];
  nativeBuildInputs = [ pkg-config git makeWrapper ];

<<<<<<< HEAD
  preFixup = ''
    for bin in $out/bin/cargo-*; do
      wrapProgram $bin \
        --set CARGO_HOME "$out/share"
=======
  preInstall = ''
    mkdir -p $out/share/
    # the directory created in the build process is .tauri-mobile, a hidden directory
    shopt -s dotglob
    for temp_dir in $HOME/*; do
      cp -R $temp_dir $out/share
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    done
  '';

  meta = with lib; {
    description = "Rust on mobile made easy! ";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
