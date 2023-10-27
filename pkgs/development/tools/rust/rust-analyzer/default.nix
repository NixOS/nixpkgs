{ lib
, stdenv
, callPackage
, fetchFromGitHub
, rustPlatform
, CoreServices
, cmake
, libiconv
, useMimalloc ? false
, enableProcMacroSrvCli ? false
, doCheck ? true
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2023-10-16";
  cargoSha256 = "sha256-hs5Mn+BU1BszgAHOZaZBQdpjeBx39Lbm+3EWSucrzak=";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-9ScvChrqG35GXwO6cFzZOgsq/5PdrUZDCTBRgkhoShk=";
  };

  cargoBuildFlags = [ "--bin" "rust-analyzer" ]
    ++ lib.optionals enableProcMacroSrvCli [ "--bin" "rust-analyzer-proc-macro-srv" ];
  cargoTestFlags = [ "--package" "rust-analyzer" ]
    ++ lib.optionals enableProcMacroSrvCli [ "--package" "proc-macro-srv-cli" ];
  RUSTC_BOOTSTRAP = enableProcMacroSrvCli;

  # Code format check requires more dependencies but don't really matter for packaging.
  # So just ignore it.
  checkFlags = [ "--skip=tidy::check_code_formatting" ];

  nativeBuildInputs = lib.optional useMimalloc cmake;

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

  buildFeatures = lib.optional useMimalloc "mimalloc"
    ++ lib.optional enableProcMacroSrvCli "sysroot-abi";

  CFG_RELEASE = version;

  inherit doCheck;
  preCheck = lib.optionalString doCheck ''
    export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
  '';

  doInstallCheck = true;
  installCheckPhase = let
    checkProcMacroSrvCli = ''
      RUST_ANALYZER_INTERNALS_DO_NOT_USE='this is unstable' \
        $out/bin/rust-analyzer-proc-macro-srv < /dev/null
    '';
  in ''
    runHook preInstallCheck
    versionOutput="$($out/bin/rust-analyzer --version)"
    echo "'rust-analyzer --version' returns: $versionOutput"
    [[ "$versionOutput" == "rust-analyzer ${version}" ]]
    ${lib.optionalString enableProcMacroSrvCli checkProcMacroSrvCli}
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
