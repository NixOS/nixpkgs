{ stdenv
, lib
, runCommand
, rustPlatform
, fetchFromGitHub
, CoreFoundation
, Security
}:
let
  version = "0.9.3";
  tauriSource = (fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    rev = "tauri-bundler-v${version}";
    sha256 = "5ca49xj4IJGj+kNCvyN8nw8Kv7ccicwuUMqjwb238cU=";
  }) + "/cli/tauri-bundler";
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

  cargoSha256 = "f55QXLm4qix52Y624pBypIPgvv0ApdT2XrWFkAK9TKM=";

  buildInputs = [ ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
  ];

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "tauri-bundler": wrap Rust executables in OS-specific app bundles'';
    homepage = "https://github.com/tauri-apps/tauri";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = [ maintainers.onsails ];
  };
}
