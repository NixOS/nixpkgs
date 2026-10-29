{
  lib,
  rustPlatform,
  llvmPackages_22, # scx_mavd fails to build on clang <= 21. FIXME: Remove once llvmPackages defaults to clang >= 22
  pkg-config,
  elfutils,
  zlib,
  zstd,
  fetchFromGitHub,
  protobuf,
  libseccomp,
  nix-update-script,
  nixosTests,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scx_rustscheds";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V+YokID74tDLR1urSeinsX3HePLBP9HFeo/NYMolH1A=";
  };

  cargoHash = "sha256-ZXn8wko5rthNkpu6BaVciKDYb1CXUQvfSmH3iSSjLZ0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    protobuf
  ];

  buildInputs = [
    elfutils
    zlib
    zstd
    libseccomp
    openssl
  ];

  env = {
    BPF_CLANG = lib.getExe llvmPackages_22.clang;
    RUSTFLAGS = lib.concatStringsSep " " [
      "-C relocation-model=pic"
      "-C link-args=-lelf"
      "-C link-args=-lz"
      "-C link-args=-lzstd"
    ];
  };

  hardeningDisable = [
    "zerocallusedregs"
  ];

  # most of the tests rely on system CPU topology info,
  # which is not available in the sandbox
  doCheck = false;

  # we don't need these
  postInstall = ''
    rm $out/bin/{scx_arena_selftests,vmlinux_docify,xtask}
  '';

  __structuredAttrs = true;
  EXPECTED_SCHEDULERS = finalAttrs.passthru.schedulers;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    cd $out/bin
    found=(scx_*)
    if [[ "''${found[@]}" != "''${EXPECTED_SCHEDULERS[@]}" ]]; then
      echo "List of available schedulers changed, expected: ''${EXPECTED_SCHEDULERS[@]}, found: ''${found[@]}"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru.tests.basic = nixosTests.scx;
  passthru.updateScript = nix-update-script { };
  passthru.schedulers = [
    "scx_arena_libarena_selftests" # tool
    "scx_beerland"
    "scx_bpfland"
    "scx_cake"
    "scx_chaos"
    "scx_characterize" # tool
    "scx_cosmos"
    "scx_eevdf"
    "scx_flash"
    "scx_flow"
    "scx_forge"
    "scx_lavd"
    "scx_layered"
    "scx_mavd"
    "scx_mitosis"
    "scx_mlfq"
    "scx_nitosis"
    "scx_p2dq"
    "scx_pandemonium"
    "scx_rlfifo"
    "scx_rustland"
    "scx_rusty"
    "scx_tickless"
  ];

  meta = {
    description = "Sched-ext Rust userspace schedulers";
    longDescription = ''
      This includes Rust based schedulers such as
      scx_rustland, scx_bpfland, scx_lavd, scx_layered, scx_rlfifo.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';

    homepage = "https://github.com/sched-ext/scx/tree/main/scheds/rust";
    changelog = "https://github.com/sched-ext/scx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      johnrtitor
      Gliczy
    ];
  };
})
