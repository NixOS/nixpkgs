{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, cmake
, libiconv
, useMimalloc ? false
# FIXME: Test doesn't pass under rustc 1.52.1 due to different escaping of `'` in string.
, doCheck ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2021-08-02";
  cargoSha256 = "10mdkqf6fqbzx49gwc283ms56yvrcdlvyk4y98jf33b8g5jmr8j5";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "1nh1naaqc6f40raz31a0vwypaxm5drzdl2bwjfqx2gydy6051gcl";
  };

  buildAndTestSubdir = "crates/rust-analyzer";

  cargoBuildFlags = lib.optional useMimalloc "--features=mimalloc";

  nativeBuildInputs = lib.optional useMimalloc cmake;

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

  RUST_ANALYZER_REV = version;

  inherit doCheck;
  preCheck = lib.optionalString doCheck ''
    export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    versionOutput="$($out/bin/rust-analyzer --version)"
    echo "'rust-analyzer --version' returns: $versionOutput"
    [[ "$versionOutput" == "rust-analyzer ${version}" ]]
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "An experimental modular compiler frontend for the Rust language";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
  };
}
