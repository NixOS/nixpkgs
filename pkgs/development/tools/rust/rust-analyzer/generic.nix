{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin
, useJemalloc ? false
, doCheck ? true

# Version specific args
, rev, version, sha256, cargoSha256 }:

rustPlatform.buildRustPackage {
  pname = "rust-analyzer-unwrapped";
  inherit version cargoSha256;

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    inherit rev sha256;
  };

  buildAndTestSubdir = "crates/rust-analyzer";

  cargoBuildFlags = lib.optional useJemalloc "--features=jemalloc";

  nativeBuildInputs = lib.optionals doCheck [ rustPlatform.rustcSrc ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin
    [ darwin.apple_sdk.frameworks.CoreServices ];

  RUST_ANALYZER_REV = rev;

  inherit doCheck;
  # Skip tests running `rustup` for `cargo fmt`.
  preCheck = ''
    fakeRustup=$(mktemp -d)
    ln -s $(command -v true) $fakeRustup/rustup
    export PATH=$PATH''${PATH:+:}$fakeRustup
    export RUST_SRC_PATH=${rustPlatform.rustcSrc}
  '';

  # Temporary disabled until #93119 is fixed.
  doInstallCheck = false;
  installCheckPhase = ''
    runHook preInstallCheck
    versionOutput="$($out/bin/rust-analyzer --version)"
    echo "'rust-analyzer --version' returns: $versionOutput"
    [[ "$versionOutput" == "rust-analyzer ${rev}" ]]
    runHook postInstallCheck
  '';

  meta = with stdenv.lib; {
    description = "An experimental modular compiler frontend for the Rust language";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
  };
}
