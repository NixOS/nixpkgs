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
<<<<<<< HEAD
  version = "2023-09-11";
  cargoSha256 = "sha256-bdF88QG++8ieFLG9H6D6nR6d9GHna36HMskp6TnTA4c=";
=======
  version = "2023-05-01";
  cargoSha256 = "sha256-ZjJ4EZYUyeO/IpiYcUaEsTx4aaNf36KoUHG3lt9gKbw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-6GjjGVCn0lNlGQifjM8AqRRMzVxf/KNyQqmAl8a9HME=";
=======
    sha256 = "sha256-FPQKPvlHIU2DsDF6GMoRtrZhil0vHi6MFd8vpKEx/n8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
