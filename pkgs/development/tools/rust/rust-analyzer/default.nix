{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, cmake
, libiconv
, useMimalloc ? false
# FIXME: Test doesn't pass under rustc 1.52.1 due to different escaping of `'` in string.
, doCheck ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2021-07-12";
  cargoSha256 = "sha256-wlo3GlB9OhyVXys5pHAqWPKHWZHzNjcQ0hiaYnp2SUc=";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-nd8valnltycywxBObSVFbt4fySEYQknFsFf5ZnEbgOk=";
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
