{ stdenv
, lib
, runCommand
, rustPlatform
, fetchFromGitHub
, CoreFoundation
, Security
}:
let
  version = "1.0.0-beta.4";
  tauriSource = (fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    rev = "tauri-bundler-v${version}";
    sha256 = "0l4cbfzypckmcpn91piysr0zljjp7saxgdffg03p4rsirnhjqw04";
  }) + "/tooling/bundler";
  tauriSourcePatched = runCommand "gen-lockfile"
    { } ''
    cp -R ${tauriSource} $out
    chmod +w $out
    cp ${./Cargo.lock} $out/Cargo.lock
  '';
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-tauri-bundler";
  inherit version;

  src = tauriSourcePatched;

  cargoSha256 = "1xszljx8m2q71hq5ni2q3ppkin0w3589xg0ycag061gci1zym95g";

  buildInputs = [ ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
  ];

  meta = with lib; {
    description = ''Cargo subcommand "tauri-bundler": wrap Rust executables in OS-specific app bundles'';
    homepage = "https://github.com/tauri-apps/tauri";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.onsails ];
  };
}
