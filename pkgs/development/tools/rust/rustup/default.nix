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
  zlib,
  Security,
  CoreServices,
  libiconv,
  xz,
}:

let
  libPath = lib.makeLibraryPath [
    zlib # libz.so.1
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "rustup";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustup";
    rev = version;
    sha256 = "sha256-rdhG9MdjWyvoaMGdjgFyCfQaoV48QtAZE7buA5TkDKg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs =
    [
      (curl.override { inherit openssl; })
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreServices
      Security
      libiconv
      xz
    ];

  buildFeatures = [ "no-self-update" ];

  checkFeatures = [ ];

  patches = lib.optionals stdenv.isLinux [
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

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

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
    export HOME=$(mktemp -d)
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}

    # generate completion scripts for rustup
    $out/bin/rustup completions bash rustup > "$out/share/bash-completion/completions/rustup"
    $out/bin/rustup completions fish rustup > "$out/share/fish/vendor_completions.d/rustup.fish"
    $out/bin/rustup completions zsh rustup >  "$out/share/zsh/site-functions/_rustup"

    # generate completion scripts for cargo
    # Note: fish completion script is not supported.
    $out/bin/rustup completions bash cargo > "$out/share/bash-completion/completions/cargo"
    $out/bin/rustup completions zsh cargo >  "$out/share/zsh/site-functions/_cargo"

    # add a wrapper script for ld.lld
    mkdir -p $out/nix-support
    substituteAll ${../../../../../pkgs/build-support/wrapper-common/utils.bash} $out/nix-support/utils.bash
    substituteAll ${../../../../../pkgs/build-support/bintools-wrapper/add-flags.sh} $out/nix-support/add-flags.sh
    substituteAll ${../../../../../pkgs/build-support/bintools-wrapper/add-hardening.sh} $out/nix-support/add-hardening.sh
    export prog='$PROG'
    export use_response_file_by_default=0
    substituteAll ${../../../../../pkgs/build-support/bintools-wrapper/ld-wrapper.sh} $out/nix-support/ld-wrapper.sh
    chmod +x $out/nix-support/ld-wrapper.sh
  '';

  env = lib.optionalAttrs (pname == "rustup") {
    inherit (stdenv.cc.bintools)
      expandResponseParams
      shell
      suffixSalt
      wrapperName
      coreutils_bin
      ;
    hardening_unsupported_flags = "";
  };

  meta = with lib; {
    description = "The Rust toolchain installer";
    homepage = "https://www.rustup.rs/";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.mic92 ];
  };
}
