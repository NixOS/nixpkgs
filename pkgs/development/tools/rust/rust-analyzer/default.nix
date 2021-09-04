{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, cmake
, libiconv
, useMimalloc ? false
, doCheck ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2021-08-30";
  cargoSha256 = "sha256-ba/4mQSBJin3yoIZjzFTiEIRY2eWFQI2pY1dOCZ1ALw=";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-mgwoJfvO3W4MYk6ikgck14e+hMjA2D+4lpnkAEeLEWA=";
  };

  patches = [
    # Code format and git history check require more dependencies but don't really matter for packaging.
    # So just ignore them.
    ./ignore-git-and-rustfmt-tests.patch
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
