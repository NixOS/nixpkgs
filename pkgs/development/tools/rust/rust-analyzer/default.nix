{ lib
, stdenv
, callPackage
, fetchFromGitHub
, rustPlatform
, CoreServices
, cmake
, libiconv
, useMimalloc ? false
, doCheck ? true
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2023-09-04";
  cargoSha256 = "sha256-J8eEHv262v21b1rs3e2seTwaKtvoGne5hXqa2jgQmoY=";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-Mk35KaY7OkEKNoj3Q3NEJ0PjFhqUd9Ry+NSzd3K1QUw=";
  };

  cargoBuildFlags = [ "--bin" "rust-analyzer" "--bin" "rust-analyzer-proc-macro-srv" ];
  cargoTestFlags = [ "--package" "rust-analyzer" "--package" "proc-macro-srv-cli" ];

  # Code format check requires more dependencies but don't really matter for packaging.
  # So just ignore it.
  checkFlags = [ "--skip=tidy::check_code_formatting" ];

  nativeBuildInputs = lib.optional useMimalloc cmake;

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

  buildFeatures = lib.optional useMimalloc "mimalloc";

  CFG_RELEASE = version;

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

  passthru = {
    updateScript = nix-update-script { };
    # FIXME: Pass overrided `rust-analyzer` once `buildRustPackage` also implements #119942
    tests.neovim-lsp = callPackage ./test-neovim-lsp.nix { };
  };

  meta = with lib; {
    description = "A modular compiler frontend for the Rust language";
    homepage = "https://rust-analyzer.github.io";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
    mainProgram = "rust-analyzer";
  };
}
