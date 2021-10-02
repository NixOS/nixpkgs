{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, cmake
, libiconv
, useMimalloc ? false
, doCheck ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2021-09-20";
  cargoSha256 = "sha256-OPolZ0oXGRcKvWxXkRMjyEXzvf1p41hGfHBpbDbLJck=";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-k2UGz+h9++8wtV+XdGZbWysjkIDe+UNudKL46eisZzw=";
  };

  patches = [
    # Code format and git history check require more dependencies but don't really matter for packaging.
    # So just ignore them.
    ./ignore-git-and-rustfmt-tests.patch

    # Patch for our rust 1.54.0 in nixpkgs. Remove it when we have rust >= 1.55.0
    ./no-1-55-control-flow.patch
  ];

  buildAndTestSubdir = "crates/rust-analyzer";

  cargoBuildFlags = lib.optional useMimalloc "--features=mimalloc";
  cargoTestFlags = lib.optional useMimalloc "--features=mimalloc";

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
