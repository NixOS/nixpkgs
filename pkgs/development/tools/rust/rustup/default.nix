{
  stdenv,
  lib,
  runCommand,
  patchelf,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  curl,
  writableTmpDirAsHomeHook,
  installShellFiles,
  zlib,
  libiconv,
  xz,
  buildPackages,
}:

let
  libPath = lib.makeLibraryPath [
    zlib # libz.so.1
  ];
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustup";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustup";
    tag = finalAttrs.version;
    hash = "sha256-iX5hEaQwCW9MuyafjXml8jV3EDnxRNUlOoy3Cur/Iyw=";
  };

  cargoHash = "sha256-KljaAzYHbny7KHOO51MotdmNpHCKWdt6kc/FIpFN6c0=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    writableTmpDirAsHomeHook
    installShellFiles
  ];

  buildInputs = [
    openssl
    curl
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    xz
  ];

  buildFeatures = [ "no-self-update" ];

  checkFeatures = [ "test" ];

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    (runCommand "0001-dynamically-patchelf-binaries.patch"
      {
        CC = stdenv.cc;
        patchelf = patchelf;
        libPath = "${libPath}";
      }
      ''
        export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
        substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
          --subst-var patchelf \
          --subst-var dynamicLinker \
          --subst-var libPath
      ''
    )
  ];

  # Random tests fail nondeterministically on macOS.
  # TODO: Investigate this.
  doCheck = !stdenv.hostPlatform.isDarwin;
  # Random failures when running tests in parallel.
  preCheck = ''
    export NIX_BUILD_CORES=1
  '';

  # skip failing tests
  checkFlags = [
    # auto-self-update mode is set to 'disable' for nix rustup
    "--skip=suite::cli_exact::check_updates_none"
    "--skip=suite::cli_exact::check_updates_some"
    "--skip=suite::cli_exact::check_updates_with_update"
    # rustup-init is not used in nix rustup
    "--skip=suite::cli_ui::rustup_init_ui_doc_text_tests"
  ];

  postInstall = ''
    pushd $out/bin
    mv rustup-init rustup
    binlinks=(
      cargo rustc rustdoc rust-gdb rust-lldb rls rustfmt cargo-fmt
      cargo-clippy clippy-driver cargo-miri rust-gdbgui rust-analyzer
    )
    for link in ''${binlinks[@]}; do
      ln -s rustup $link
    done
    popd

    wrapProgram $out/bin/rustup --prefix "LD_LIBRARY_PATH" : "${libPath}"

    # tries to create .rustup
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}

    ${lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
      let
        emulator = stdenv.hostPlatform.emulator buildPackages;
      in
      ''
        # generate completion scripts for rustup
        installShellCompletion --cmd rustup \
          --bash <(${emulator} $out/bin/rustup completions bash rustup) \
          --fish <(${emulator} $out/bin/rustup completions fish rustup) \
          --zsh <(${emulator} $out/bin/rustup completions zsh rustup)

        # generate completion scripts for cargo
        # Note: fish completion script is not supported.
        installShellCompletion --cmd cargo \
          --bash <(${emulator} $out/bin/rustup completions bash cargo) \
          --zsh <(${emulator} $out/bin/rustup completions zsh cargo)
      ''
    )}

    # add a wrapper script for ld.lld
    mkdir -p $out/nix-support
    substituteAll ${../../../../../pkgs/build-support/wrapper-common/utils.bash} $out/nix-support/utils.bash
    substituteAll ${../../../../../pkgs/build-support/wrapper-common/darwin-sdk-setup.bash} $out/nix-support/darwin-sdk-setup.bash
    substituteAll ${../../../../../pkgs/build-support/bintools-wrapper/add-flags.sh} $out/nix-support/add-flags.sh
    substituteAll ${../../../../../pkgs/build-support/bintools-wrapper/add-hardening.sh} $out/nix-support/add-hardening.sh
    export prog='$PROG'
    export use_response_file_by_default=0
    substituteAll ${../../../../../pkgs/build-support/bintools-wrapper/ld-wrapper.sh} $out/nix-support/ld-wrapper.sh
    chmod +x $out/nix-support/ld-wrapper.sh
  '';

  env = {
    inherit (stdenv.cc.bintools)
      expandResponseParams
      shell
      suffixSalt
      wrapperName
      coreutils_bin
      ;
    hardening_unsupported_flags = "";
  };

  meta = {
    description = "Rust toolchain installer";
    homepage = "https://www.rustup.rs/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mic92
    ];
    mainProgram = "rustup";
  };
})
